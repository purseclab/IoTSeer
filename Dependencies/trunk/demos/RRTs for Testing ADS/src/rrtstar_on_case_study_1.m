%% Get the state of the random number generator
rand_seed = rng;
tic;

%% Parameters
keep_global_cost_at_nodes = true; % Otherwise, keeps local cost since the last config.
max_rrt_iter = 5000;
sim_dt = 0.01;
search_dt = 2.5;
random_sampler = @in_road_random_path_sampler;
random_sampler_opts.temp_path_len = 100;
prev_config_finder = @find_best_config_w_dist_angle;
%prev_config_finder = @return_last_config;
prev_config_finder_opts.anchor_agent = 1;
prev_config_finder_opts.num_minimum = 5;
simulator = @simulate_vehicles;
immediate_cost_fnc = @ttc_and_impact_pt_cost;
transition_check_fnc = @transition_check;
transition_check_options.T = 0.01;
transition_check_options.nFail = 0;
transition_check_options.nFail_max = 5;
transition_check_options.alpha = 2;
transition_check_options.K = 100;

sim_env = SimulationEnvironment.instance(sim_dt);

%% Book keeping
configurations = []; % An array for the relations between corresponding nodes.
terminal_configs = []; % Marks the vertices that violates constraints and hence are not extensible.
config_history = [];  % Keeps a track of which config evolves to which config.
num_rejected_transition = 0;
num_accepted_transition = 0;
num_rejected_novelty = 0;
num_accepted_novelty = 0;

%% Define set of initial states for agent and ego vehicles
agent(1).x0_s = [[20, 30]; [-3.5, 3.5]; [0 0]; [0, 15]];  %[x,y,theta,v]
%agent(2).x0_s = [[190, 200]; [-4, 4]; [pi pi]; [0, 20]];
agent(2).x0_s = [[0, 25]; [-3.5, 3.5]; [0 0]; [0, 15]];
ego(1).x0_s = [[40, 50]; [-1.75, 1.75]; [-pi/8 pi/8]; [10, 15]; [0, 0]]; %[x,y,theta,v,ang_v]

% Create an object that will do the novelty computations.
novelty_checker = RelativeStateBasedNovelty(ego, agent);
%novelty_checker = AcceptAllNovelty(ego, agent);

%% Define sample space for agent vehicles
agent(1).x_s = [[10, 3000]; [-4, 4]; [-pi/4 pi/4]; [0, 30]];
%agent(2).x_s = [[0, 190]; [-4, 4]; [pi-pi/4 pi+pi/4]; [0, 20]];
agent(2).x_s = [[5, 3000]; [-4, 4]; [-pi/4 pi/4]; [0, 30]];

%% Sample initial states for agent and ego vehicles
for ii = 1:length(agent)
    agent(ii).x0 = rand_between(agent(ii).x0_s(:,1), agent(ii).x0_s(:,2));
end
for ii = 1:length(ego)
    ego(ii).x0 = rand_between(ego(ii).x0_s(:, 1), ego(ii).x0_s(:, 2));
end

%% Define vehicle parameters and create vehicles
for ii = 1:length(agent)
    agent(ii).veh = Car('dt',sim_dt, 'x0',agent(ii).x0);
    K_alpha = 3; K_beta = -1; K_a = 0.5;
    agent(ii).veh.add_driver(MoveToPoseDriverNoCollision(K_alpha, K_beta, K_a));
    agent(ii).veh.driver.set_sim_env(sim_env, ii);
end
for ii = 1:length(ego)
    ego(ii).veh = DynamicCar('dt',sim_dt, 'x0',ego(ii).x0);
    %ego(ii).veh.add_driver(ConvoyMPCwithStanley());
    ego(ii).veh.add_driver(PIDACCwithStanley());
    ego(ii).veh.driver.perception_system = PerceptionSystem('ego', ii);
    % front radar
    v_len = ego(ii).veh.front_length + ego(ii).veh.rear_length;
    sensor_id = 1; sensor_pos = [v_len,0]'; sensor_orient = 0; 
    sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
    sensor_ang_range = [-pi/8, pi/8]; sensor_dist_rang = [0, 60];
    ego(ii).veh.driver.perception_system.add_sensor(...
        Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
                sensor_time_delay, sensor_noise, sensor_period, ...
                sensor_ang_range, sensor_dist_rang) );
            
    % right radar
    sens_x = v_len*0.5 - ego(ii).veh.rear_length;
    sensor_id = 2; sensor_pos = [sens_x,-ego(ii).veh.width/2]'; sensor_orient = -pi/2; 
    sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
    sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
    ego(ii).veh.driver.perception_system.add_sensor(...
        Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
                sensor_time_delay, sensor_noise, sensor_period, ...
                sensor_ang_range, sensor_dist_rang) );
            
    % front-left radar
    sensor_id = 3; sensor_pos = [sens_x,ego(ii).veh.width/2]'; sensor_orient = pi/2; 
    sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
    sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
    ego(ii).veh.driver.perception_system.add_sensor(...
        Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
                sensor_time_delay, sensor_noise, sensor_period, ...
                sensor_ang_range, sensor_dist_rang) );
            
%     % front-right radar
%     sens_x = v_len*0.8 - ego(ii).veh.rear_length;
%     sensor_id = 2; sensor_pos = [sens_x,-ego(ii).veh.width/2]'; sensor_orient = -pi/2; 
%     sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
%     sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
%     ego(ii).veh.driver.perception_system.add_sensor(...
%         Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
%                 sensor_time_delay, sensor_noise, sensor_period, ...
%                 sensor_ang_range, sensor_dist_rang) );
%             
%     % front-left radar
%     sensor_id = 3; sensor_pos = [sens_x,ego(ii).veh.width/2]'; sensor_orient = pi/2; 
%     sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
%     sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
%     ego(ii).veh.driver.perception_system.add_sensor(...
%         Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
%                 sensor_time_delay, sensor_noise, sensor_period, ...
%                 sensor_ang_range, sensor_dist_rang) );
%             
%     % rear-right radar
%     sens_x = v_len*0.2 - ego(ii).veh.rear_length;
%     sensor_id = 4; sensor_pos = [sens_x,-ego(ii).veh.width/2]'; sensor_orient = -pi/2; 
%     sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
%     sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
%     ego(ii).veh.driver.perception_system.add_sensor(...
%         Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
%                 sensor_time_delay, sensor_noise, sensor_period, ...
%                 sensor_ang_range, sensor_dist_rang) );
%             
%     % rear-left radar
%     sensor_id = 5; sensor_pos = [sens_x,ego(ii).veh.width/2]'; sensor_orient = pi/2; 
%     sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
%     sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 10];
%     ego(ii).veh.driver.perception_system.add_sensor(...
%         Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
%                 sensor_time_delay, sensor_noise, sensor_period, ...
%                 sensor_ang_range, sensor_dist_rang) );
            
    % rear-right-corner radar
    sens_x = -ego(ii).veh.rear_length;
    sensor_id = 4; sensor_pos = [sens_x,-ego(ii).veh.width/2]'; sensor_orient = -pi*140/180; 
    sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
    sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 30];
    ego(ii).veh.driver.perception_system.add_sensor(...
        Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
                sensor_time_delay, sensor_noise, sensor_period, ...
                sensor_ang_range, sensor_dist_rang) );
            
    % rear-left-corner radar
    sensor_id = 5; sensor_pos = [sens_x,ego(ii).veh.width/2]'; sensor_orient = pi*140/180; 
    sensor_time_delay = 0; sensor_noise = []; sensor_period = 0.01;
    sensor_ang_range = [-pi/4, pi/4]; sensor_dist_rang = [0, 30];
    ego(ii).veh.driver.perception_system.add_sensor(...
        Sensor('radar', sensor_id, sensor_pos, sensor_orient, ...
                sensor_time_delay, sensor_noise, sensor_period, ...
                sensor_ang_range, sensor_dist_rang) );
            
    ego(ii).veh.driver.set_simulation_environment(sim_env);
    % TODO: Add path to follow to the Ego vehicle
    %ego(ii).veh.driver.add_to_target_path(ego(ii).x0 + [1000.0; 0.0; 0.0; 0.0]);
end

%% Initialize exploration graphs of agent and ego vehicles.
g_ndims = 3;
for ii = 1:length(agent)
    agent(ii).G = ExplorationGraph(g_ndims, 'distance', @angled_distance);
    node_id = agent(ii).G.add_node(agent(ii).x0(1:3));
    vdata = TreeNodeData(agent(ii).x0);
    agent(ii).G.setvdata(node_id, vdata);
    configurations(1).agent_node(ii) = node_id; %#ok<*SAGROW>
end
for ii = 1:length(ego)
    ego(ii).G = ExplorationGraph(g_ndims, 'distance', @angled_distance);
    node_id = ego(ii).G.add_node(ego(ii).x0(1:3));
    vdata = TreeNodeData(ego(ii).x0);
    ego(ii).G.setvdata(node_id, vdata);
    configurations(1).ego_node(ii) = node_id;
end
configurations(1).end_time = 0;
configurations(1).cost = 10000;
configurations(1).cost_aux = {};
configurations(1).novelty = 0;

%% Search
last_r_i = 1;
r_i = 1;
disp('----- Starting RRT* ------');
datetime
starttime = tic;
max_duration_s = 600;
while toc(starttime) < max_duration_s %r_i < max_rrt_iter
    %if (mod(r_i, 10) == 0 || mod(r_i, uint32(0.1*max_rrt_iter)) == 0) && r_i ~= last_r_i
    %    disp(['RRT: ', num2str(r_i), '/', num2str(max_rrt_iter)]);
        %datetime
    %end
    last_r_i = r_i;
    new_config_id = length(configurations) + 1;

    % Sample temp_target_path for agents.
    agent = random_sampler(random_sampler_opts, agent, ego);
    
    % -------- This is the RRT* part where we search for best prev node.
    % Find the best previous configuration. (Best Neighbor)
    prev_config_ids = prev_config_finder(prev_config_finder_opts, ...
        configurations, agent, terminal_configs);
    costs = inf*ones(length(prev_config_ids), 1);
    cost_auxs = cell(length(prev_config_ids), 1);
    for prev_c_i = 1:length(prev_config_ids)
        temp_prev_config_id = prev_config_ids(prev_c_i);
        prev_config = configurations(temp_prev_config_id);
        start_time = prev_config.end_time;

        % Find previous tree nodes
        best_v_agent = [];
        for a_i = 1:length(agent)
            best_v_agent(a_i) = prev_config.agent_node(a_i);
            if sign(abs(agent(a_i).temp_target_path(3,1)) - pi/2) ~= ...
                    sign(abs(agent(a_i).G.vertexlist(3,best_v_agent(a_i))) - pi/2)
                disp(['different directions ',num2str(new_config_id)])
            end
        end
        best_v_ego = [];
        for e_i = 1:length(ego)
            best_v_ego(e_i) = prev_config.ego_node(e_i);
        end
    
        % Simulate vehicles.
        [agent_out, ego_out] = simulator(agent, ego, search_dt, ...
                        best_v_agent, best_v_ego, sim_env, start_time);

        % Check if we will add the new node.
        % Corresponds to Transition Test in Transition-based RRT
        [costs(prev_c_i), cost_auxs{prev_c_i}] = ...
            immediate_cost_fnc(ego_out, agent_out, sim_env, start_time);
    end
    % Get the data for the minimum cost case to use later:
    [cost, best_i] = min(costs);
    cost_aux = cost_auxs{best_i};
    prev_config_id = prev_config_ids(best_i);
    prev_config = configurations(prev_config_id);
    start_time = prev_config.end_time;
    for a_i = 1:length(agent)
        best_v_agent(a_i) = prev_config.agent_node(a_i);
    end
    for e_i = 1:length(ego)
        best_v_ego(e_i) = prev_config.ego_node(e_i);
    end
    if length(prev_config_ids) > 1 && best_i ~= length(prev_config_ids)
        % Resimulate the best case because it was overwritten by the
        % simulator.
        [agent_out, ego_out] = simulator(agent, ego, search_dt, ...
                        best_v_agent, best_v_ego, sim_env, start_time);
    end
    % --------- End of RRT*-related part. -----------
    % We don't have the rewiring part of RRT* because as soon as we go to a
    % new node, we need to simulate and control the vehicles toward that
    % configuration and we will end up in a different configuration. Also,
    % we need to simulate child node of that as well. What we do is 
    % different from an obstacle-free path search in 2D world.
    
    [transition_okay, transition_check_options] = ...
        transition_check_fnc(transition_check_options, prev_config.cost, cost);
    num_accepted_transition = num_accepted_transition + double(transition_okay);
    num_rejected_transition = num_rejected_transition + double(~transition_okay);
    if transition_okay
        % Check Novelty.
        [is_novel, novelty, all_novelty] = novelty_checker.compute_novelty(ego_out, agent_out);
        num_accepted_novelty = num_accepted_novelty + double(is_novel); % Bookkeeping
        num_rejected_novelty = num_rejected_novelty + double(~is_novel);
        if is_novel || cost < 0.95*prev_config.cost
            % Update search graphs with the simulation results.
            for ii = 1:length(agent_out)
                if ~isempty(agent_out(ii).veh.x_hist)
                    % Add the result as a new node.
                    new_v = agent(ii).G.add_node(agent_out(ii).veh.x_hist(end, 1:3));
                    newvdata = TreeNodeData(agent_out(ii).veh.x_hist(end, :)');
                    % Update vertex data with the target_path that wasused.
                    newvdata.target_path = agent(ii).temp_target_path;
                    newvdata.x_hist = agent_out(ii).veh.x_hist;
                    newvdata.u_hist = agent_out(ii).veh.u_hist;
                    newvdata.controller_state = agent_out(ii).veh.driver.get_states();
                    newvdata.cur_time = agent(ii).G.vdata(best_v_agent(ii)).cur_time + length(agent_out(ii).veh.x_hist)*agent_out(ii).veh.dt;
                    agent(ii).G.setvdata(new_v, newvdata);
                    % Connect previous state with the new one.
                    agent(ii).G.add_edge(best_v_agent(ii), new_v);
                    configurations(new_config_id).agent_node(ii) = new_v;
                    if is_state_invalid(newvdata.x, agent(ii))
                        % We never set to "false" here because it may override a
                        % "true" that was set from another agent.
                        terminal_configs(new_config_id) = true;
                    end
                end
            end
            for ii = 1:length(ego_out)
                if ~isempty(ego_out(ii).veh.x_hist)
                    % Add the result as a new node.
                    new_v = ego(ii).G.add_node(ego_out(ii).veh.x_hist(end, 1:3));
                    newvdata = TreeNodeData(ego_out(ii).veh.x_hist(end, :)');
                    newvdata.x_hist = ego_out(ii).veh.x_hist;
                    newvdata.u_hist = ego_out(ii).veh.u_hist;
                    newvdata.controller_state = ego_out(ii).veh.driver.get_states();
                    newvdata.cur_time = ego(ii).G.vdata(best_v_ego(ii)).cur_time + length(ego_out(ii).veh.x_hist)*ego_out(ii).veh.dt;
                    ego(ii).G.setvdata(new_v, newvdata);
                    % Connect previous state with the new one.
                    ego(ii).G.add_edge(best_v_ego(ii), new_v);
                    configurations(new_config_id).ego_node(ii) = new_v;
                end
            end
            configurations(new_config_id).novelty = novelty;
            if keep_global_cost_at_nodes
                cost = min(cost, prev_config.cost);
            end
            configurations(new_config_id).cost = cost;
            configurations(new_config_id).cost_aux = cost_aux;
            configurations(new_config_id).end_time = start_time + length(ego_out(1).veh.x_hist)*ego_out(1).veh.dt;
            config_history(end+1,:) = [prev_config_id, new_config_id];
            if ~isempty(sim_env.collisions)
                terminal_configs(new_config_id) = true;
            end
            r_i = r_i+1;
            % TODO: Stop search (mark as final config) if all agent and ego vehicles are on opposite
            % directions and passed each other (no hope for future collision).
        end %transition check
    end %novelty check
end
total_time_passed = toc;
tt = datetime('now');
fname = ['../log/rrtstar_',num2str(tt.Year),num2str(tt.Month),num2str(tt.Day),'_',num2str(tt.Hour),'_',num2str(tt.Minute)]
save(fname);


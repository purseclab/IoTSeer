clear all
close all
temp_t = datetime('now');
rng(int32(temp_t.Hour*10000+temp_t.Minute*100+temp_t.Second));

while (1)
    clear all;
    temp_t = datetime('now');
    rng(int32(temp_t.Hour*10000+temp_t.Minute*100+temp_t.Second));
    try
        keep_global_cost_at_nodes = true;
        generate_test;
    catch e %e is an MException struct
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
    rng(int32(temp_t.Hour*10000+temp_t.Minute*100+temp_t.Second));
    clear all;
    try
        keep_global_cost_at_nodes = false;
        generate_test;
    catch e %e is an MException struct
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
end

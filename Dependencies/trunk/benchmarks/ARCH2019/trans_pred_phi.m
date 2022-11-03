
phi{1} = '[]_[0,20] speed120';
phi{2} = '[]_[0,10] rpm4750';
phi{3} = '[]_[0, 30] ((!(gear1) /\ X (gear1))-> X []_[0, 2.5] (gear1))';
phi{4} = '[]_[0, 30] ((!(gear2) /\ X (gear2))-> X []_[0, 2.5] (gear2))';
phi{5} = '[]_[0, 30] ((!(gear3) /\ X (gear3))-> X []_[0, 2.5] (gear3))';
phi{6} = '[]_[0, 30] ((!(gear4) /\ X (gear4))-> X []_[0, 2.5] (gear4))';
phi{7} = '([]_[0, 30] (rpm3000) ->[]_[0, 4] (speed35))';
phi{8} = '([]_[0, 30] (rpm3000) ->[]_[0, 8] (speed50))';
phi{9} = '([]_[0, 30] (rpm3000) ->[]_[0, 20] (speed65))';

phi_{3} = '[]_[0, 30] !(!(gear1)/\<>_[0.001, 0.1](gear1))';
phi_{4} = '[]_[0, 30] !(!(gear2) /\ <>_[0.001, 0.1] (gear2))';
phi_{5} = '[]_[0, 30] !(!(gear3) /\ <>_[0.001, 0.1] (gear3))';
phi_{6} = '[]_[0, 30] !(!(gear4) /\ <>_[0.001, 0.1] (gear4))';
phi_{7} = '([]_[0, 30] !(rpm3000))';
phi_{8} = '([]_[0, 30] !(rpm3000))';
phi_{9} = '([]_[0, 30] !(rpm3000))';

ii = 1;
preds(ii).str = 'gear1';
preds(ii).A = [];
preds(ii).b = [];
preds(ii).loc = 1;

ii = ii+1;
preds(ii).str = 'gear2';
preds(ii).A = [];
preds(ii).b = [];
preds(ii).loc = 2;

ii = ii+1;
preds(ii).str = 'gear3';
preds(ii).A = [];
preds(ii).b = [];
preds(ii).loc = 3;

ii = ii+1;
preds(ii).str = 'gear4';
preds(ii).A = [];
preds(ii).b = [];
preds(ii).loc = 4;

ii = ii+1;
preds(ii).str='speed120';
preds(ii).A = [1 0];
% preds(ii).A = [1];
% preds(ii).proj = 1;
preds(ii).b = 120;
preds(ii).loc = 1;

ii = ii+1;
preds(ii).str='speed35';
preds(ii).A = [1 0];
% preds(ii).A = [1];
% preds(ii).proj = 1;
preds(ii).b = 35;
preds(ii).loc = 1:4;

ii = ii+1;
preds(ii).str='speed50';
preds(ii).A = [1 0];
% preds(ii).A = [1];
% preds(ii).proj = 1;
preds(ii).b = 50;
preds(ii).loc = 1:4;

ii = ii+1;
preds(ii).str='speed65';
preds(ii).A = [1 0];
% preds(ii).A = [1];
% preds(ii).proj = 1;
preds(ii).b = 65;
preds(ii).loc = 1:4;


ii = ii+1;
preds(ii).str='rpm3000';
preds(ii).A = [0 1];
% preds(ii).A = [1];
% preds(ii).proj = 2;
preds(ii).b = 3000;
preds(ii).loc = 1:4;

ii = ii+1;
preds(ii).str='rpm4750';
preds(ii).A = [0 1];
% preds(ii).A = [1];
% preds(ii).proj = 2;
preds(ii).b = 4750;
preds(ii).loc = 1:4;

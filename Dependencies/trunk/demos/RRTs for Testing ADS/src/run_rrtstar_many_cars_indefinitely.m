clear all
close all
temp_t = datetime('now');
rng(int32(temp_t.Hour*10000+temp_t.Minute*100+temp_t.Second));

while (1)
    clear all;
    temp_t = datetime('now');
    rng(int32(temp_t.Hour*10000+temp_t.Minute*100+temp_t.Second));
    try
        rrtstar_many_cars;
    catch e %e is an MException struct
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
end

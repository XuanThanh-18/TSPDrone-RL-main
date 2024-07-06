
# divide-partition-and-search (DPS) heuristic
function divide_partition_search(
    Ct::Matrix{Float64},
    Cd::Matrix{Float64};
    n_groups::Int = 1, 
    local_search_methods::Vector{Function} = Function[two_point_move, one_point_move, two_opt_move], 
    flying_range::Float64 = MAX_DRONE_RANGE, 
    time_limit::Float64 = MAX_TIME_LIMIT
)

    time0 = time()

    n1, n2 = size(Ct)
    n_nodes = n1 - 1

    @assert size(Ct) == size(Cd)

    tsp_tour = find_tsp_tour(Ct[1:end-1, 1:end-1])
    push!(tsp_tour, n_nodes+1) # adding the final depot

    total_tspd_len = 0.0
    total_t_route = Int[]
    total_d_route = Int[] 
    # @show tsp_tour 

    n = n_nodes + 1
    group_size = Int((floor(n / n_groups)))

    remaining_time_limit = time_limit - (time() - time0)
    time_limit_each_group = remaining_time_limit / n_groups 

    for i in 1:n_groups
        start_idx = 1 + group_size * (i-1)
        end_idx = min(1 + group_size * i, n)

        group_idx = start_idx:end_idx
        group_nodes = tsp_tour[group_idx]

        Ct_ = Ct[group_nodes, group_nodes]
        Cd_ = Cd[group_nodes, group_nodes]
        init_tour = collect(1:length(group_nodes))
    
        tspd_len, t_route_idx, d_route_idx = tsp_ep_all(Ct_, Cd_, init_tour; local_search_methods=local_search_methods, flying_range=flying_range, time_limit=time_limit_each_group)   
        
        total_tspd_len += tspd_len
        append!(total_t_route, group_nodes[t_route_idx])
        append!(total_d_route, group_nodes[d_route_idx])
    end

    unique!(total_t_route)
    unique!(total_d_route)

    obj_val = objective_value(total_t_route, total_d_route, Ct, Cd)
    @assert isapprox(obj_val, total_tspd_len)

    # @show total_tspd_len

    return total_tspd_len, total_t_route, total_d_route
    
end

"""
    log_growth_matrix(dataset::Dict{String, DataFrame}, firms::Array{String,1}; ...)

Computes the excess log growth matrix for a list of firms.
"""
function log_growth_matrix(dataset::Dict{String, DataFrame}, 
    firms::Array{String,1}; Δt::Float64 = (1.0/252.0), risk_free_rate::Float64 = 0.0, 
    testfirm="AAPL", keycol::Symbol = :volume_weighted_average_price)::Array{Float64,2}

    # initialize -
    number_of_firms = length(firms);
    number_of_trading_days = nrow(dataset[testfirm]);
    return_matrix = Array{Float64,2}(undef, number_of_trading_days-1, number_of_firms);

    # main loop -
    for i ∈ eachindex(firms) 
        # get the firm data -
        firm_index = firms[i];
        firm_data = dataset[firm_index];

        # compute the log returns -
        for j ∈ 2:number_of_trading_days
            S₁ = firm_data[j-1, keycol];
            S₂ = firm_data[j, keycol];
            return_matrix[j-1, i] = (1/Δt)*(log(S₂/S₁)) - risk_free_rate;
        end
    end

    # return -
    return return_matrix;
end

"""
    learn_return_distribution_mcmc(returns::Vector{Float64}; samples::Int = 2000)

Uses a Bayesian MCMC approach to learn the parameters of a Student's t-distribution
fitted to the equity returns data.

Returns a Turing.jl `Chain` object containing the posterior distributions of the parameters.
"""
function learn_distribution_mcmc(model_type::AbstractDistributionModel, 
    returns::Vector{Float64}; samples::Int = 2000)
    
    # 1. Build the correct model based on the input type (e.g., StudentTModel())
    #    Julia's multiple dispatch calls the correct function from Factory.jl
    model_instance = build_turing_model(model_type, returns)

    # 2. Run the MCMC sampler
    chain = Turing.sample(model_instance, NUTS(), samples)

    # 3. Return the resulting chain
    return chain
end
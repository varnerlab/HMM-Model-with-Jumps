abstract type AbstractMarkovModel end
abstract type AbstractDistributionModel end

"""
    mutable struct MyHiddenMarkovModel <: AbstractMarkovModel

The `MyHiddenMarkovModel` mutable struct represents a hidden Markov model (HMM) with discrete states.

### Required fields
- `states::Array{Int64,1}`: The states of the model
- `transition::Dict{Int64, Categorical}`: The transition matrix of the model encoded as a dictionary where the `key` is the state and the `value` is a `Categorical` distribution
- `emission::Dict{Int64, Categorical}`: The emission matrix of the model encoded as a dictionary where the `key` is the state and the `value` is a `Categorical` distribution   
"""
mutable struct MyHiddenMarkovModel <: AbstractMarkovModel
    
    # data -
    states::Array{Int64,1}
    transition::Dict{Int64, Categorical}
    emission::Dict{Int64, Categorical}

    # constructor -
    MyHiddenMarkovModel() = new();
end

"""
    mutable struct MyHiddenMarkovModelWithJumps <: AbstractMarkovModel

The `MyHiddenMarkovModelWithJumps` mutable struct represents a hidden Markov model (HMM) with discrete states and jump dynamics.

### Required fields
- `states::Array{Int64,1}`: The states of the model
- `transition::Dict{Int64, Categorical}`: The transition matrix of the model encoded as a dictionary where the `key` is the state and the `value` is a `Categorical` distribution
- `inverse_transition::Dict{Int64, Categorical}`: The inverse transition matrix of the model encoded as a dictionary where the `key` is the state and the `value` is a `Categorical` distribution
- `emission::Dict{Int64, Categorical}`: The emission matrix of the model encoded as a dictionary where the `key` is the state and the `value` is a `Categorical` distribution
- `ϵ::Float64`: The jump probability
- `λ::Float64`: The jump distribution parameter
- `jump_distribution::Poisson`: The jump distribution
"""
mutable struct MyHiddenMarkovModelWithJumps <: AbstractMarkovModel
    
    # data -
    states::Array{Int64,1}
    transition::Dict{Int64, Categorical}
    inverse_transition::Dict{Int64, Categorical}; # high-low probability states reversed
    emission::Dict{Int64, Categorical}
    ϵ::Float64; # jump probability
    λ::Float64; # jump distribution parameter
    jump_distribution::Poisson; # jump distribution

    # constructor -
    MyHiddenMarkovModelWithJumps() = new();
end


"""
    StudentTModel <: AbstractDistributionModel

A concrete type representing a model based on the Student's t-distribution.
Used for dispatch to select the appropriate simulation or fitting methods.
"""
struct StudentTModel <: AbstractDistributionModel end

"""
    LaplaceModel <: AbstractDistributionModel

A concrete type representing a model based on the Laplace distribution.
Used for dispatch to select the appropriate simulation or fitting methods.
"""
struct LaplaceModel <: AbstractDistributionModel end
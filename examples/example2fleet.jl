# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.4'
#       jupytext_version: 1.2.4
#   kernelspec:
#     display_name: Julia 1.3.1
#     language: julia
#     name: julia-1.3
# ---

# # This notebook
#
# _Notes:_ For more documentation see <https://docs.juliadiffeq.org/latest/solvers/ode_solve.html> and <https://en.wikipedia.org/wiki/Displacement_(vector)>

# ## 1. Import Software

using IndividualDisplacements, OrdinaryDiffEq
using Plots, Statistics, DataFrames
p=dirname(pathof(IndividualDisplacements))
include(joinpath(p,"../examples/plot_Plots.jl"))

# ## 2. Setup Problem

# +
uvetc=IndividualDisplacements.example2_setup()

#ii1=1:10:80; ii2=1:10:42; #->sol is (2, 40, 40065)
#ii1=30:37; ii2=16:20; #->sol is (2, 40, 9674)
#ii1=10:17; ii2=16:20; #->sol is (2, 40, 51709)
ii1=5:5:40; ii2=5:5:25; #->sol is (2, 40, 51709)

n1=length(ii1); n2=length(ii2);
u0=Array{Float64,2}(undef,(2,n1*n2))
for i1 in eachindex(ii1); for i2 in eachindex(ii2);
        i=i1+(i2-1)*n1
        u0[1,i]=ii1[i1]-0.5
        u0[2,i]=ii2[i2]-0.5
end; end;
# -

# ## 3. Compute Trajectories
#
# - Define an ODE problem.
# - Solve the ODE problem to compute trajectories.

𝑇 = (0.0,2998.0*3600.0)
prob = ODEProblem(⬡,u0,𝑇,uvetc)

sol = solve(prob,Tsit5(),reltol=1e-6,abstol=1e-6)
size(sol)

# ## 4. Display results

# +
ID=collect(1:size(sol,2))*ones(1,size(sol,3))
lon=5000* mod.(sol[1,:,:],80); lat=5000* mod.(sol[2,:,:],42)
df = DataFrame(ID=Int.(ID[:]), lon=lon[:], lat=lat[:])

plt=PlotBasic(df,size(sol,2),100000.0)
display(plt)
# -

df_from_mitgcm=ReadDisplacements("flt_example/",Float32)
plt=PlotBasic(df_from_mitgcm,40,100000.0)
display(plt)


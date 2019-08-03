using Statistics
using DataFrames
using CSV

f = "/home/user/Downloads/scaling_data_2019-08-01T23:41:13.633.csv";

df = CSV.read(f) |> DataFrame;

df_ = df[df[:n] .== 2^20, :];
mean(df_[:Δ_method_2])
mean(df_[:Δ_method_2_t_0])
mean(df_[:Δ_method_2_t_1])

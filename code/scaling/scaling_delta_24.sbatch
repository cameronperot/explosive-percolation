#!/bin/sh
#SBATCH -p batch
#SBATCH -t 48:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=3
#SBATCH --mem 60000
#SBATCH -o scaling_delta_24.stdout
#SBATCH -e scaling_delta_24.sterr

cd /home/perot/julia/scaling
export PATH="/home/perot/julia/julia-1.1.1/bin:$PATH"
export JULIA_NUM_THREADS=3

julia scaling_delta.jl \
	--graph_type Network \
	--evolution_method stochastic_edge_acceptance \
	--k_min 24 \
	--k_max 24 \
	--n_sims 100 \
	--starting_seed $1

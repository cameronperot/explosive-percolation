#!/bin/sh
#SBATCH -p crc
#SBATCH -t 48:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem 120000
#SBATCH -o scaling_delta_test.stdout
#SBATCH -e scaling_delta_test.sterr

cd /home/perot/julia/scaling
export PATH="/home/perot/julia/julia-1.1.1/bin:$PATH"
export JULIA_NUM_THREADS=16

julia scaling_delta.jl \
	--graph_type Network \
	--evolution_method stochastic_edge_acceptance \
	--k_min 15 \
	--k_max 16 \
	--n_sims 10 \
	--starting_seed 1

#!/bin/sh
#SBATCH -p batch
#SBATCH -t 48:00:00
#SBATCH --nodes=1
#SBATCH --mem 60000
#SBATCH -o scaling_observables.stdout
#SBATCH -e scaling_observables.sterr

cd /home/perot/julia/scaling
export PATH="/home/perot/julia/julia-1.1.1/bin:$PATH"

julia scaling_observables.jl

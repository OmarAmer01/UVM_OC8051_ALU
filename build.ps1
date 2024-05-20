rm work -r


# Compile everything
vlog -f .\filelist.f +lint  +fcover +cover

# Simulate
vsim tb_top -do "sim.do" -voptargs=+acc -assertdebug -coverage -sv_seed random -cvgperinstance -c

# Get Coverage Report
vcover report -details -html -output ./cov_rep cov_db.ucdb

# Open The Report
Invoke-item ./cov_rep/index.html
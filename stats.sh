dumpstats() {
 cat $1 | awk '{if ($1=="FRNN") t+=$4;}END{print t}'
}

### R/K GRAPHICS ###
rk_graphics() {
  for i in 1
  do
    for r in 0.001 0.005 0.01 0.05 0.1 0.2
    do
      echo -n "r "$r" "
      dumpstats "buddha-r${r}-k50-run${i}.out"
    done
  
    for k in 1 4 16 32 50 64 128
    do
      echo -n "k "$k" "
      dumpstats "buddha-r0.05-k${k}-run${i}.out"
    done
  done
}

### R/K N-BODY ###
rk_nbody() {
  for i in 1
  do
    for r in 1 2 8 10 32 128
    do
      echo -n "r "$r" "
      dumpstats "nbody-9m-r$r-k50-run${i}.out"
    done

    for k in 1 4 16 32 50 64 128
    do
      echo -n "k "$k" "
      dumpstats "nbody-9m-r32-k$k-run${i}.out"
    done
  done
}

### ALL EVAL ###
all_eval() {
  for i in 1
  do
    dumpstats "kitti-120k-r2-k50-run${i}.out"
    dumpstats "kitti-1m-r2-k50-run${i}.out"
    dumpstats "kitti-6m-r2-k50-run${i}.out"
    dumpstats "kitti-12m-r2-k50-run${i}.out"
  
    dumpstats "nbody-9m-r32-k50-run${i}.out"
    dumpstats "nbody-10m-r32-k50-run${i}.out"
  
    dumpstats "buddha-r0.05-k50-run${i}.out"
    dumpstats "bunny-r0.05-k50-run${i}.out"
    dumpstats "dragon-r2-k50-run${i}.out"
  done
}

### R/K KITTI ###
rk_kitti() {
  for i in 1
  do
    for r in 0.01 0.1 2 16 50
    do
      echo -n "r "$r" "
      dumpstats "kitti-6m-r${r}-k50-run${i}.out"
    done
  
    for k in 1 4 16 32 50 64 100 128 200
    do
      echo -n "k "$k" "
      dumpstats "kitti-6m-r2-k${k}-run${i}.out"
    done
  done
}

rk_kitti
rk_nbody
rk_graphics
exit
all_eval


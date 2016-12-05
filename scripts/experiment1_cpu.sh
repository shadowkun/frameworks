#!/bin/bash

#=======================================================================
# Copyright (c) 2016 Baptiste Wicht
# Distributed under the terms of the MIT License.
# (See accompanying file LICENSE or copy at
#  http://opensource.org/licenses/MIT)
#=======================================================================

######################
# Experiment 1 (CPU) #
######################

exp=1
mode=cpu

echo "Starting experiment 1 (CPU)"

#  DLL  #
#########

echo "Starting DLL"

mkdir -p results/$exp/$mode/dll

cd dll/

# Set variables for performance
export DLL_BLAS_PKG=mkl-threads
export ETL_MKL=true
make clean > /dev/null
make release/bin/experiment1 > /dev/null
before=`date "+%s"`
./release/bin/experiment1 | tee ../results/$exp/$mode/dll/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

# Cleanup variables
unset DLL_BLAS_PKG
unset ETL_MKL

cd ..

#  TF  #
########

cd tf

echo "Starting TensorFlow"

mkdir -p results/$exp/$mode/tf

source ~/.virtualenvs/tf/bin/activate

before=`date "+%s"`
CUDA_VISIBLE_DEVICES=-1 python experiment1.py | tee ../results/$exp/$mode/tf/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

deactivate

cd ..

#  Keras  #
###########

cd keras

echo "Starting Keras"

mkdir -p results/$exp/$mode/keras

source ~/.virtualenvs/tf/bin/activate

before=`date "+%s"`
CUDA_VISIBLE_DEVICES=-1 python experiment1.py | tee ../results/$exp/$mode/keras/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

deactivate

cd ..

#  DeepLearning4J  #
####################

echo "Starting DeepLearning4j"

mkdir -p results/$exp/$mode/dl4j

cd dl4j

export DL4J_MODE=native
mvn clean install > /dev/null

cd target/classes

before=`date "+%s"`
java -cp ../ihatejava-0.7-SNAPSHOT-bin.jar wicht.experiment1 | tee ../results/$exp/$mode/dl4j/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

cd ../..

cd ..

#  Caffe  #
###########

cd caffe

echo "Starting Caffe"

mkdir -p results/$exp/$mode/caffe

export CAFFE_ROOT="/home/wichtounet/dev/caffe-cpu"

before=`date "+%s"`
$CAFFE_ROOT/build/tools/caffe train --solver=experiment1_solver.prototxt | tee ../results/$exp/$mode/caffe/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

cd ..

#  Torch  #
###########

cd torch

echo "Starting Torch"

mkdir -p results/$exp/$mode/torch

source ~/torch/install/bin/torch-activate

before=`date "+%s"`
th experiment1.lua | tee ../results/$exp/$mode/torch/raw_results
after=`date "+%s"`
echo "Time: $((after - before))"

cd ..

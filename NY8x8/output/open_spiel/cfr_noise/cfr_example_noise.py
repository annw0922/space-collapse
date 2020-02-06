# Copyright 2019 DeepMind Technologies Ltd. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Example use of the CFR algorithm on Kuhn Poker."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from absl import app
from absl import flags

from open_spiel.python.algorithms import cfr
from open_spiel.python import policy
from open_spiel.python.algorithms import exploitability
import pyspiel
import csv
import numpy as np

FLAGS = flags.FLAGS

flags.DEFINE_integer("iterations", 10000, "Number of iterations")
flags.DEFINE_string("game", "matrix_mp", "Name of the game")
flags.DEFINE_integer("players", 2, "Number of players")
flags.DEFINE_integer("print_freq", 1000, "How often to print the exploitability")

game_ = "von_poker_6"
algo_name = "cfr_noise"
dir_ = "../recorder/"


def write_csv(filename,data):
    with open(filename,"a") as f:
        f_csv = csv.writer(f)
        f_csv.writerow(data)
def noise_(exp,target):
    b = np.random.randn(*target.shape)*exp*0.05
    b = b-np.sum(b)/np.size(b)
    bb = target + b
    bb = abs(bb)
    bb = bb/sum(bb)
    return bb
def main(_):
  game = pyspiel.load_game_as_turn_based(game_,)
  cfr_solver = cfr.CFRSolver(game)

  print("policy_initial:",cfr_solver.current_policy().action_probability_array)
  for i in range(FLAGS.iterations):
    
    if i % FLAGS.print_freq == 0:
      conv = exploitability.exploitability(game, cfr_solver.average_policy())
      print("Iteration {} exploitability {}".format(i, conv))
      print("Iteration{}".format(i))
      
      print("policy_av:",cfr_solver.average_policy().action_probability_array)
      print("policy_cr:",cfr_solver.current_policy().action_probability_array) 
      
    cfr_solver.evaluate_and_update_policy()
    conv = exploitability.exploitability(game, cfr_solver.average_policy())
    cfr_solver.current_policy().action_probability_array[0] =noise_(conv,cfr_solver.current_policy().action_probability_array[0])
    cfr_solver.current_policy().action_probability_array[1] =noise_(conv,cfr_solver.current_policy().action_probability_array[1])
 
    write_csv(dir_+game_+"_"+algo_name+"_exp.csv",[conv])
    write_csv(dir_+game_+"_"+algo_name+"_av.csv",cfr_solver.average_policy().action_probability_array[0])
    write_csv(dir_+game_+"_"+algo_name+"_av.csv",cfr_solver.average_policy().action_probability_array[1])
    write_csv(dir_+game_+"_"+algo_name+"_cr.csv",cfr_solver.current_policy().action_probability_array[0])
    write_csv(dir_+game_+"_"+algo_name+"_cr.csv",cfr_solver.current_policy().action_probability_array[1])

if __name__ == "__main__":
  app.run(main)

# 目录

* [研究进展](#研究进展)
* [关于open_spiel的使用](#关于open_spiel的使用)

### 研究进展


### 关于open_spiel的使用
open_spiel的github:[https://github.com/deepmind/open_spiel](https://github.com/deepmind/open_spiel)

#### 我的实验环境:
* Ubuntu 18.04
* anaconda3,python3.7
* 2张TITAN Xp,两张TITAN V.Driver Version 396.54

#### 安装方式:
安装按照:[https://arxiv.org/pdf/1908.09453.pdf](https://arxiv.org/pdf/1908.09453.pdf)第6页2.1节
以及2.1.1节设置路径,然后按照2.2的尝试样例就ok.跑了一次完全按照就行,没有任何坑.

#### 增加样例:
增加自定义博弈见open_spiel的[developer guide](https://github.com/deepmind/open_spiel/blob/master/docs/developer_guide.md)的Adding a game部分,在增加自定义博弈的过程中c++与python没有区别,均在`/open_spiel/games`里面.

当如果只需要添加bimatrix game,在`/open_spiel/games/matrix_games.cc`里面照样子增加一例,拿本次实验的(m,n)=(2,1)的game:
```c
namespace von_poker_6 {  /*必须更改namespace*/
// Facts about the game
const GameType kGameType{
    /*short_name=*/"von_poker_6",  /*必须更改short_name*/
    /*long_name=*/"Von poker(game=6)",
    GameType::Dynamics::kSimultaneous,
    GameType::ChanceMode::kExplicitStochastic,
    GameType::Information::kOneShot,
    GameType::Utility::kZeroSum,
    GameType::RewardModel::kTerminal,
    /*max_num_players=*/2,
    /*min_num_players=*/2,
    /*provides_information_state_string=*/true,
    /*provides_information_state_tensor=*/true,
    /*parameter_specification=*/{}  // no parameters
};

std::shared_ptr<const Game> Factory(const GameParameters& params) {
  return std::shared_ptr<const Game>(new MatrixGame(
      kGameType, params, {"a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8"},
      {"b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8"}, 
      {0,0,0,0,0,0,0,0,\ 
0,0,1,1,1,1,2,2,\ 
2,-1,2,-1,3,0,3,0,\ 
2,-1,3,0,4,1,5,2,\ 
4,1,1,-2,4,1,1,-2,\ 
4,1,2,-1,5,2,3,0,\ 
6,0,3,-3,7,1,4,-2,\ 
6,0,4,-2,8,2,6,0},
      {0,0,0,0,0,0,0,0,\ 
0,0,-1,-1,-1,-1,-2,-2,\ 
-2,1,-2,1,-3,0,-3,0,\ 
-2,1,-3,0,-4,-1,-5,-2,\ 
-4,-1,-1,2,-4,-1,-1,2,\ 
-4,-1,-2,1,-5,-2,-3,0,\ 
-6,0,-3,3,-7,-1,-4,2,\ 
-6,0,-4,2,-8,-2,-6,0}));
}

REGISTER_SPIEL_GAME(kGameType, Factory);
}  // namespace von_poler game6```
其中GameType可选设置以及解释见[`open_spiel/spiel.h`](https://github.com/deepmind/open_spiel/blob/master/open_spiel/spiel.h)
每次更改完game以后需要重新在`build/`路径下`make -j$(nproc)`

#### 运行算法(bimatrix game):
* [cfr](#####cfr)
##### cfr

Counterfactual Regret Minimization科普介绍：
* [Counterfactual Regret Minimization – the core of Poker AI beating professional players](https://int8.io/counterfactual-regret-minimization-for-poker-ai/)
* [An Introduction to Counterfactual Regret Minimization](http://modelai.gettysburg.edu/2013/cfr/cfr.pdf)(附带java code)
* 整理笔记了一哈：[https://github.com/annw0922/space-collapse/blob/master/cfr_.md](https://github.com/annw0922/space-collapse/blob/master/cfr_.md)

另外open spiel提供了[cfr_br](https://poker.cs.ualberta.ca/publications/AAAI12-cfrbr.pdf)算法和[deep_cfr](https://arxiv.org/abs/1811.00164)算法,但在我们的较小的bimatrix game情况用不上.

在`open_spiel/python/examples/cfr_example.py`下进行.
cfr算法要求sequential game,直接将kuhn_poker改成对应bimatrixgame会报错如下:
>Spiel Fatal Error: CFR requires sequential games. If you're trying to run it on a simultaneous (or normal-form) game, please first transform it using turn_based_simultaneous_game.

需要更换load_game命令:
```diff
def main(_):
-  game = pyspiel.load_game(FLAGS.game,
-                           {"players": pyspiel.GameParameter(FLAGS.players)})
+  game = pyspiel.load_game_as_turn_based("von_poker_6",)
```

此时直接跑会报错`RuntimeError: UtilitySum unimplemented.`
我的做法是自行定义bimatrix game的utilitysum,即在`/open_spiel/matrix_game.h`里的
```
class MatrixGame : public NormalFormGame {
 public:
```
 
 里增加
 ```
 double UtilitySum() const override { return 0; }
 ```
 (然后要重新make)

 在`cfr`的情况下,可以通过调用
 
 ```py
 print("policy_av:",cfr_solver.average_policy().action_probability_array)
 print("policy_cr:",cfr_solver.current_policy().action_probability_array)
 ```
来输出当前的

```py
def write_csv(filename,data):
    with open(filename,"a") as f:
        f_csv = csv.writer(f)
        f_csv.writerow(data)
        
write_csv(dir_+game_+"_"+algo_name+"_av.csv",cfr_solver.average_policy().action_probability_array[0])
write_csv(dir_+game_+"_"+algo_name+"_av.csv",cfr_solver.average_policy().action_probability_array[1])
write_csv(dir_+game_+"_"+algo_name+"_cr.csv",cfr_solver.current_policy().action_probability_array[0])
write_csv(dir_+game_+"_"+algo_name+"_cr.csv",cfr_solver.current_policy().action_probability_array[1])
```
来写文档。

实验结果:
博弈收敛速率(通过exploitation)
<div align=center><img width="500" height="500" alt="收敛速率" src="https://github.com/annw0922/space-collapse/blob/master/NY8x8/output/open_spiel/cfr_noise/exploitability_noise.jpg"/></div>

<div align=center><img width="500" height="400" alt="g6" src="https://github.com/annw0922/space-collapse/blob/master/NY8x8/output/open_spiel/cfr_noise/cfr_noise_6.jpg"/></div>

<div align=center><img width="500" height="400" alt="g8" src="https://github.com/annw0922/space-collapse/blob/master/NY8x8/output/open_spiel/cfr_noise/cfr_noise_8.jpg"/></div>

<div align=center><img width="500" height="400" alt="g10" src="https://github.com/annw0922/space-collapse/blob/master/NY8x8/output/open_spiel/cfr_noise/cfr_noise_10.jpg"/></div>

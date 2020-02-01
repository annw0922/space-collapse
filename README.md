# space-collapse
SEDS

# 目录

* [研究进展](#研究进展)
* [关于open_spiel的使用](#关于open_spiel的使用)

### 研究进展


### 关于open_spiel的使用
open_spiel的github:[https://github.com/deepmind/open_spiel](https://github.com/deepmind/open_spiel)

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
}  // namespace von_poler game6
```
其中GameType可选设置以及解释见[`open_spiel/spiel.h`](https://github.com/deepmind/open_spiel/blob/master/open_spiel/spiel.h)
每次更改完game以后需要重新在`build/`路径下`make -j$(nproc)`

#### 运行算法(bimatrix game):
* [cfr](#####cfr)
##### cfr
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



    


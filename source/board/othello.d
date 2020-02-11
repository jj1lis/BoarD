module board.othello;

import std.conv:to;
import std.typecons;

import board.base;

class Othello{
    private:
        alias OthelloBoard=Board!(Piece.empty,Camp);
        OthelloBoard _board;
        Player!Camp[2] _players;

        auto canPut(Coordinate coor,Camp camp){
            if(_board.isEmpty(coor)){
                return false;
            }else{
                //TODO
                return true;
            }
        }

        auto routine(Player!Camp player){
            import std.algorithm,std.array;
            assert((){foreach(p;_players){if(player==p)return true;}return false;});
            Coordinate[] candidates=_board.exists_squares.array.filter!(c=>canPut(c,player.camp)).array;
        }

    public:
        @property{
            auto board(){return _board;}
        }

        enum Piece{
            black,
            white,
            empty
        }

        enum Camp{
            black,
            white
        }

        string function(Piece) PieceToString=(p){
            switch(p){
                case Piece.black:
                    return BackColor.black~" ";
                case Piece.white:
                    return BackColor.white~" ";
                case Piece.empty:
                    return " ";
                default:
                    assert(0);
            }
        };

        string function(int) rawToString=(raw)=>(raw+'a').to!char.to!string;

        string function(int) columnToString=(column)=>(column+1).to!string;

        this(Player!Camp[2] _players){
            this._players=_players;

            auto othello_coor(){
                Coordinate[] coors;
                foreach(raw;0..8){
                    foreach(column;0..8){
                        coors~=Coordinate(raw,column);
                    }
                }
                return coors;
            }
            _board=new OthelloBoard(othello_coor,OthelloBoard.Piece(Piece.empty),
                    [tuple(Coordinate(3,3),OthelloBoard.Piece(Piece.white,_players[0])),
                    tuple(Coordinate(3,4),OthelloBoard.Piece(Piece.black,_players[1])),
                    tuple(Coordinate(4,3),OthelloBoard.Piece(Piece.black,_players[1])),
                    tuple(Coordinate(4,4),OthelloBoard.Piece(Piece.white,_players[0]))]);
        }

        void print(){
            _board.print!(PieceToString,rawToString,columnToString);
        }
}

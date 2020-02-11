import std.stdio;
import std.typecons;
import std.conv:to;

import board.base;
import board.othello;

void main(){

    alias Camp=Othello.Camp;
    alias MyBoard=Board!(Piece.empty,Camp);
    Player!(Camp)[2] players=[Player!Camp(Camp.black,"Taro"),Player!Camp(Camp.white,"Jiro")];

    auto othello_coor(){
        Coordinate[] coors;
        foreach(raw;0..8){
            foreach(column;0..8){
                coors~=Coordinate(raw,column);
            }
        }
        return coors;
    }
    auto board=new MyBoard(othello_coor,MyBoard.Piece(Piece.empty),
            [tuple(Coordinate(3,3),MyBoard.Piece(Piece.white,players[0])),
            tuple(Coordinate(3,4),MyBoard.Piece(Piece.black,players[1])),
            tuple(Coordinate(4,3),MyBoard.Piece(Piece.black,players[1])),
            tuple(Coordinate(4,4),MyBoard.Piece(Piece.white,players[0]))]);

    auto p2s=(Piece p){
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
    auto r2s=(int raw){
        return (raw+'a').to!char.to!string;
    };
    auto c2s=(int column){
        return (column+1).to!string;
    };
    //board.print!(p2s,r2s,c2s);

    auto othello=new Othello(players);
    othello.print;
    //othello.print;
}

alias Piece=Othello.Piece;
//enum Piece{
//    black,
//    white,
//    empty
//}

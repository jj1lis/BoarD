import std.stdio;
import std.typecons;
import std.conv:to;

import board.base;
import board.othello;

void main(){

    alias Camp=Othello.Camp;
    Player!(Camp)[2] players=[Player!Camp(Camp.black,"Taro"),Player!Camp(Camp.white,"Jiro")];
    auto p2s=(Piece p){
        switch(p){
            case Piece.black:
                return BackColor.black~" ";
            case Piece.white:
                return BackColor.white~BackColor.white~" ";
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

    auto othello=new Othello(players);
    othello.startGame;
}

alias Piece=Othello.Piece;
//enum Piece{
//    black,
//    white,
//    empty
//}

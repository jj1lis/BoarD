import std.stdio;
import std.typecons;

import board.base;

void main(){
    alias Othello=Board!(Piece.empty);

    auto othello_coor(){
        Coordinate[] coors;
        foreach(raw;0..8){
            foreach(column;0..8){
                coors~=Coordinate(raw,column);
            }
        }
        return coors;
    }
    auto board=new Othello(othello_coor,Piece.empty,
            [tuple(Coordinate(3,3),Piece.white),tuple(Coordinate(3,4),Piece.black),
            tuple(Coordinate(4,3),Piece.black),tuple(Coordinate(4,4),Piece.white)]);
    board.back_color=BackColor.yellow;
    board.char_color=CharColor.black;


    auto p2d=(Piece p){
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
    board.print!(p2d)(7);
}

enum Piece{
    black,
    white,
    empty
}

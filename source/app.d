import std.stdio;
import std.typecons;

import board.base;

void main(){
    alias Fuga=Board!(Piece,Piece.empty);
    Fuga fuga=new Fuga([tuple(Coordinate(3,2),Piece.empty)]);
    fuga.print(hoge=>'a');
    fuga.square(Coordinate(3,2)).writeln;
}

enum Piece{
    black,
    white,
    empty
}

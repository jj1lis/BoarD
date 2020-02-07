import std.stdio;
import std.typecons;

import board.base;

void main(){
    alias Fuga=Board!(Piece);
    Fuga fuga=new Fuga([tuple(Matrix(3,2),Piece.empty)]);
    fuga.print(hoge=>'a');
    fuga.square(Matrix(3,2)).writeln;
}

enum Piece{
    black,
    white,
    empty
}

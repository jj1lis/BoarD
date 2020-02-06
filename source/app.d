import std.stdio;

import board.base;

void main(){
    auto board=new Board!(
{
    size_t raw_max=8;
    size_t column_max=5;
    enum status{
        Black,
        White,
        Empty
    }
}
);
}

static class MyRule{
    size_t raw_max=8;
    size_t column_max=5;
    enum status{
        Black,
        White,
        Empty
    }
}

module board.base;

import std.typecons;

struct Matrix{
    private:
    size_t _raw;
    size_t _column;

    public:
    @property{
        auto raw(){return _raw;}
        auto column(){return _column;}
    }

    this(size_t _raw,size_t _column){
        this._raw=_raw;
        this._column=_column;
    }
}

class Board(T_Piece){
    import std.stdio;

    private:
    T_Piece[Matrix] _squares;
    Matrix[] _exists_squares;

    BackColor _back_color=BackColor.green;
    CharColor _char_color=CharColor.black;
    auto _writeln(string text){
        writeln(_back_color~_char_color~text~"\033[0m");
    }

    public:

    alias TMP=Tuple!(Matrix,T_Piece);//Tuple of Matrix and Piece

    invariant(_squares.length==_exists_squares.length);

    @property{
        auto squares(){return _squares;}
        auto exists_squares(){return _exists_squares;}
        auto square(Matrix matrix){
            import core.exception;
            try{
                return _squares[matrix];
            }catch(RangeError re){
                throw new NoMatrixException(matrix);
            }
        }
        auto back_color(BackColor c){_back_color=c;}
        auto char_color(CharColor c){_char_color=c;}
    }

    class NoMatrixException:Exception{
        this(Matrix matrix){
            import std.conv:to;
            auto msg="\nMatrix("~matrix.raw.to!string~", "~matrix.column.to!string~
                ") doesn't exists in squares.\nCheck Matrix exists by using Board!(yourType).exists(Matrix) .";
            super(msg);
        }
    }

    this(TMP[] init_set){
        foreach(e;init_set){
            _squares[e[0]]=e[1];
            _exists_squares~=e[0];
        }
    }

    auto exists(Matrix matrix){
        return (matrix in _squares)!=null?true:false;
    }

    void print(dchar delegate(T_Piece) pieceToDchar){
        if(_exists_squares.length==0){
            "No Squares in Board.".writeln;
        }else{
            this._writeln("TEST!");
        }
    }
}

enum CharColor:string{
    black="\033[30m",
    red="\033[31m",
    green="\033[32m",
    yellow="\033[33m",
    blue="\033[34m",
    magent="\033[35m",
    cyan="\033[36m",
    white="\033[37m"
}

enum BackColor:string{
    black="\033[40m",
    red="\033[41m",
    green="\033[42m",
    yellow="\033[43m",
    blue="\033[44m",
    magent="\033[45m",
    cyan="\033[46m",
    white="\033[47m"
}

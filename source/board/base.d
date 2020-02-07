module board.base;

class Board(T_Piece){
    private:
    T_Piece[Matrix] _squares;
    Matrix[] _exists_squares;

    string _back_color="\330[42m";
    string _char_color="\330[30m";
    auto _writeln(string text){
        import std.stdio:writeln;
        writeln(_back_color~_char_color~text~"\330[0m");
    }

    public:

    alias Tuple!(Matrix,T_Piece) TMP;//Tuple of Matrix and Piece

    invariant(_squares.length==_exists_squares.length);

    @property{
        auto squares(){return _squares;}
        auto exists_squares(){return _exists_squares;}

        auto square(Matrix matrix){
            if(!this.exists(matrix)){
                return null;
            }else{
                return _squares[matrix];
            }
        }
    }

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

    this(TMP init_set){
        import std.algorithm;
        init_set.each!(e=>_squares[e[0]]=e[1]);
        _exists_squares=init_set.map!(e=>e[0]).array;
    }

    auto exists=(Matrix matrix)=>(matrix in _exists_squares)!=null?true:false;

    void print(dchar delegate(T_Piece) pieceToDchar){
        import std.stdio;
        if(_exists_squares.length==0){
            "No Squares in Board.".writeln;
        }else{
            //TODO
        }
    }
}

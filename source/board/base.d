module board.base;

import std.typecons;

struct Coordinate{
    private:
        int _raw;
        int _column;

    public:
        @property{
            auto raw(){return _raw;}
            auto column(){return _column;}
        }

        this(int _raw,int _column){
            this._raw=_raw;
            this._column=_column;
        }
}

struct Set(T){
    private:
        T[] _set;

    public:
        @property{
            inout array(){return _set;}
            inout length(){return _set.length;}
            auto clear(){_set.length=0;}
        }

        auto insert(T t){
            if(!isIncluded(t)){
                _set~=t;
            }
        }

        auto remove(T t){
            import std.algorithm,std.array;
            _set=_set.filter!(s=>s!=t).array;
        }

        auto isIncluded(T t){
            foreach(e;_set){
                if(e==t)return true;
            }
            return false;
        }
}

class Board(T_Piece,alias empty)if(is(typeof(empty)==T_Piece)){
    import std.stdio;

    private:
    T_Piece[Coordinate] _squares;
    Set!(Coordinate) _exists_squares;

    BackColor _back_color=BackColor.green;
    CharColor _char_color=CharColor.black;

    auto _writeln(string text){
        writeln(_back_color~_char_color~text~"\033[0m");
    }

    public:
    import core.exception;

    @property{
        auto squares(){return _squares;}
        auto exists_squares(){return _exists_squares;}
        auto square(Coordinate coor){
            try{
                return _squares[coor];
            }catch(RangeError re){
                throw new NoCoordinateException(coor);
            }
        }
        auto back_color(BackColor c){_back_color=c;}
        auto char_color(CharColor c){_char_color=c;}
    }

    invariant(_squares.length==_exists_squares.length);

    class NoCoordinateException:Exception{
        this(Coordinate coor){
            import std.conv:to;
            auto msg="\nCoordinate("~coor.raw.to!string~", "~coor.column.to!string~
                ") doesn't exists in squares.\nCheck Coordinate exists by using Board!(yourType).existSquare(Coordinate) .";
            super(msg);
        }
    }

    this(Tuple!(Coordinate,T_Piece)[] init_set){
        foreach(s;init_set){
            this._squares[s[0]]=s[1];
            this._exists_squares.insert(s[0]);
        }
    }

    this(Coordinate[] coors,T_Piece init_default,Tuple!(Coordinate,T_Piece)[] init_specified=[]){
        foreach(coor;coors){
            this._squares[coor]=init_default;
            this._exists_squares.insert(coor);
        }

        if(init_specified.length!=0){
            foreach(s;init_specified){
                this._squares[s[0]]=s[1];
                this._exists_squares.insert(s[0]);
            }
        }
    }

    auto put(Coordinate coor,T_Piece piece){
        try{
            _squares[coor]=piece;
        }catch(RangeError re){
            throw new NoCoordinateException(coor);
        }
    }

    auto pick(Coordinate coor){
        try{
            auto swap=_squares[coor];
            _squares[coor]=empty;
            return swap;
        }catch(RangeError re){
            throw new NoCoordinateException(coor);
        }
    }

    auto existSquare(Coordinate coor){
        return (coor in _squares)!=null?true:false;
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

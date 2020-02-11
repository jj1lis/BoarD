module board.base;

import std.algorithm;
import std.range;
import std.conv:to;
import std.typecons;

import board.othello;

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
            import std.array;
            _set=_set.filter!(s=>s!=t).array;
        }

        auto isIncluded(T t){
            foreach(e;_set){
                if(e==t)return true;
            }
            return false;
        }
}


struct Player(Camp){
    private:
        string _name;
        Camp _camp;

    public:
        @property{
            auto name(){return _name;}
            auto camp(){return _camp;}
        }

        this(Camp _camp,string _name){
            this._camp=_camp;
            this._name=_name;
        }
}

class Board(alias empty,Camp){
    import std.stdio;

    private:

    Tuple!(Coordinate,"coor",Piece,"piece")[Coordinate] _squares;
    Set!(Coordinate) _exists_squares;
    enum color_reset="\033[0m";

    BackColor _back_color=BackColor.green;
    CharColor _char_color=CharColor.white;

    auto _write(string text){
        write(_back_color~_char_color~text~color_reset);

    }

    auto _writeln(string text){
        writeln(_back_color~_char_color~text~color_reset);
    }


    public:
    import core.exception;
    import app;
    alias T_Piece=typeof(empty);

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
        auto back_color(){return _back_color;}
        auto char_color(CharColor c){_char_color=c;}
        auto char_color(){return _char_color;}
    }

    invariant(_squares.length==_exists_squares.length);

    class NoCoordinateException:Exception{
        this(Coordinate coor){
            auto msg="\nCoordinate("~coor.raw.to!string~", "~coor.column.to!string~
                ") doesn't exists in squares.\nCheck Coordinate exists by using Board!(yourType).existSquare(Coordinate) .";
            super(msg);
        }
    }

    struct Piece{
        private:
            T_Piece _piece;
            Player!Camp _master;
        public:
            @property{
                auto piece(){return _piece;}
                auto master(){return _master;}
            }

            this(T_Piece _piece,Player!Camp _master){
                this._piece=_piece;
                this._master=_master;
            }

            this(T_Piece _piece){
                if(_piece==empty){
                    this._piece=empty;
                }else{
                    throw new Exception("TODO");//TODO
                }
            }
    }

    this(Tuple!(Coordinate,Piece)[] init_set){
        foreach(s;init_set){
            this._squares[s[0]]=s;
            this._exists_squares.insert(s[0]);
        }
    }

    this(Coordinate[] coors,Piece init_default=Piece(empty),Tuple!(Coordinate,Piece)[] init_specified=[]){
        foreach(coor;coors){
            this._squares[coor]=tuple(coor,init_default);
            this._exists_squares.insert(coor);
        }

        if(init_specified.length!=0){
            foreach(s;init_specified){
                this._squares[s[0]]=s;
                this._exists_squares.insert(s[0]);
            }
        }
    }

    auto put(Coordinate coor,Piece piece){
        try{
            _squares[coor].piece=piece;
        }catch(RangeError re){
            throw new NoCoordinateException(coor);
        }
    }

    auto pick(Coordinate coor){
        try{
            auto swap=_squares[coor];
            _squares[coor].piece=Piece(empty);
            return swap;
        }catch(RangeError re){
            throw new NoCoordinateException(coor);
        }
    }

    auto isEmpty(Coordinate coor){
        try{
            return _squares[coor].piece.piece==empty;
        }catch(RangeError re){
            throw new NoCoordinateException(coor);
        }
    }

    auto existSquare(Coordinate coor){
        return _exists_squares.isIncluded(coor);
    }

    void print(alias PieceToString=(p){return "@";},
            alias rawToString=(r){return r.to!string;},
            alias columnToString=(c){return c.to!string;})
            (lazy size_t width=7){
        if(_exists_squares.length==0){
            "No Squares in Board.".writeln;
        }else{
            auto raw_sorted=_exists_squares.array.map!(c=>c.raw).array.sort;
            auto column_sorted=_exists_squares.array.map!(c=>c.column).array.sort;
            auto lens_raw=iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(i=>rawToString(i).length>width?i:width);
            auto lenmax_column=iota(column_sorted.fold!min,column_sorted.fold!max+1).map!(i=>columnToString(i).length).fold!max;

            _writeln(" ".repeat(lenmax_column).join~" "~iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(
                        (i){
                        auto len=rawToString(i).length;
                        if(width>len){
                        if((width-len)%2==0){
                        auto space=" ".repeat((width-len)/2).join;
                        return space~rawToString(i)~space;
                        }else{
                        auto space=" ".repeat((width-len)/2).join;
                        return space~rawToString(i)~space~" ";
                        }
                        }else{
                        return rawToString(i);
                        }
                        }).join(" ")~" ");
            _writeln(" ".repeat(lenmax_column).join~"+"~iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(i=>"-".repeat(lens_raw[i]).join).join("+")~"+");
            foreach(column;iota(column_sorted.fold!min,column_sorted.fold!max+1)){
                _writeln(" ".repeat(lenmax_column).join~"|"~iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(
                            (i){
                            if(!existSquare(Coordinate(i,column))&&!existSquare(Coordinate(i+1,column))){
                            return " ".repeat(lens_raw[i]).join~" ";
                            }else{
                            return " ".repeat(lens_raw[i]).join~"|";
                            }
                            }).join);
                _writeln(" ".repeat(lenmax_column-columnToString(column).length).join~columnToString(column)~"|"~
                        iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(
                            (i){
                            string str;
                            if(existSquare(Coordinate(i,column))){
                            import std.regex;
                            auto piece=PieceToString(_squares[Coordinate(i,column)].piece.piece);
                            //typeof(piece).stringof.writeln;
                            //auto piece=" ";
                            //auto tmp=(lens_raw[i]-piece.splitter("\033").array.length+1)/2;
                            auto space_front=(lens_raw[i]-piece.replace(regex("\033.*m","g"),"").length)/2;
                            //auto space_front=(lens_raw[i]-(piece.length)+1)/2;
                            //"line".writeln;
                            //writefln("space_front:%s piece.length:%s space_front+piece.length:%s",space_front,piece.length,space_front+piece.length);
                            //writeln(lens_raw[i]-(space_front+piece.length));
                            str~=" ".repeat(space_front).join~
                            piece~back_color~char_color~
                            " ".repeat(lens_raw[i]-space_front-1).join;
                            }else{
                            str~=" ".repeat(lens_raw[i]).join;
                            }
                            if(!existSquare(Coordinate(i,column))&&!existSquare(Coordinate(i+1,column))){
                                str~=" ";
                            }else{
                                str~="|";
                            }
                            //"return str".writeln;
                            return str;
                            }).join);
                _writeln(" ".repeat(lenmax_column).join~"|"~iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(
                            (i){
                            if(!existSquare(Coordinate(i,column))&&!existSquare(Coordinate(i+1,column))){
                            return " ".repeat(lens_raw[i]).join~" ";
                            }else{
                            return " ".repeat(lens_raw[i]).join~"|";
                            }
                            }).join);
                _writeln(" ".repeat(lenmax_column).join~"+"~iota(raw_sorted.fold!min,raw_sorted.fold!max+1).map!(
                            (i){
                            if(!existSquare(Coordinate(i,column))&&!existSquare(Coordinate(i,column+1))){
                            return " ".repeat(lens_raw[i]).join~"+";
                            }else{
                            return "-".repeat(lens_raw[i]).join~"+";
                            }
                            }).join);
            }
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

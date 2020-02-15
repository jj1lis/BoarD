module board.othello;

import std.stdio;
import std.conv:to;
import std.algorithm;
import std.typecons;

import board.base;

class Othello{
    private:
        alias OthelloBoard=Board!(Piece.empty,Camp);
        OthelloBoard _board;
        Player!Camp[2] _players;

        auto canPut(Coordinate coor,Camp camp){
            if(_board.isEmpty(coor)){
                foreach(line;surroundLines(coor)){
                    if(line.length>1&&_board.square(line[0]).piece.type!=Piece.empty&&_board.square(line[0]).piece.master.camp!=camp){
                        //line.length.writeln;
                        foreach(piece;line[1..$-1].map!(c=>_board.square(c).piece)){
                            if(piece.type==Piece.empty){
                                break;
                            }else if(piece.master.camp==camp){
                                return true;
                            }
                        }
                    }
                }
            }
            return false;
        }

        auto surroundLines(Coordinate coor){
            Coordinate[][] lines;
            lines~=getLine(coor,Coordinate(1,0));
            lines~=getLine(coor,Coordinate(1,1));
            lines~=getLine(coor,Coordinate(0,1));
            lines~=getLine(coor,Coordinate(-1,1));
            lines~=getLine(coor,Coordinate(-1,0));
            lines~=getLine(coor,Coordinate(-1,-1));
            lines~=getLine(coor,Coordinate(0,-1));
            lines~=getLine(coor,Coordinate(1,-1));
            return lines;
        }

        auto getLine(Coordinate center,Coordinate add){
            Coordinate[] line;
            for(Coordinate coor=center+add;_board.existSquare(coor);coor=coor+add){
                line~=_board.square(coor).coordinate;
            }
            return line;
        }

        auto reverse(Piece piece){
            assert(piece!=Piece.empty);
            return piece==Piece.black?Piece.white:Piece.black;
        }

        auto reverse(Player!Camp player){
            assert((){foreach(p;_players){if(player==p)return true;}return false;});
            return player==_players[0]?_players[1]:_players[0];
        }

        auto turnOver(Coordinate coor){
            assert(!_board.isEmpty(coor));
            auto former=_board.pick(coor);
            _board.put(coor,OthelloBoard.Piece(reverse(former.type),reverse(former.master)));
        }

        auto routine(Player!Camp player){
            assert((){foreach(p;_players){if(player==p)return true;}return false;});

            print;
            writefln("It's your turn:%s",player.name);

            import std.array;
            Coordinate[] candidates=_board.exists_squares.array.filter!(c=>canPut(c,player.camp)).array;

            if(candidates.length==0){
                "Can't put your piece.".writeln;
            }else{
                bool validity=false;
                bool delegate()putable=(){return false;};
                Coordinate coor_put;
                while(!validity||!putable()){
                    //while(true){
                    "Enter a square you put your piece. >".write;
                    import std.string;
                    auto input=readln.chomp.dup;
                    if(input=="print"){
                        print;
                        continue;
                    }
                    validity=(input.length==2&&_board.existSquare(Coordinate(charToRaw(input[0]),charToColumn(input[1]))));
                    if(validity){
                        coor_put=Coordinate(charToRaw(input[0]),charToColumn(input[1]));
                        putable=(){foreach(c;candidates){if(coor_put==c)return true;}return false;};
                        if(!putable()){
                            "You can't put a piece there.".writeln;
                        }
                    }else{
                        "Invalid input. Follow format <raw><column>".writeln;
                        "Example: a1".writeln;
                    }
                }

                Coordinate[] be_turned;
                auto lines=surroundLines(coor_put);
                auto base=CampToPiece(player.camp);
                foreach(line;lines){
                    Coordinate[] buff;
                    foreach(coor;line){
                        if(_board.square(coor).piece.type==base||_board.square(coor).piece.type==Piece.empty){
                            if(_board.square(coor).piece.type==base)be_turned~=buff;
                            break;
                        }
                        buff~=coor;
                    }
                }
                _board.put(coor_put,OthelloBoard.Piece(CampToPiece(player.camp),player));
                be_turned.each!(c=>turnOver(c));
            }
        }

        auto CampToPiece(Camp camp){
            return camp==Camp.black?Piece.black:Piece.white;
        }



    public:
        @property{
            auto board(){return _board;}
        }

        enum Piece{
            black,
            white,
            empty
        }

        enum Camp{
            black,
            white
        }

        string function(Piece) PieceToString=(p){
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

        string function(int) rawToString=(raw)=>(raw+'a').to!char.to!string;

        string function(int) columnToString=(column)=>(column+1).to!string;

        int function(char) charToRaw=(raw)=>(raw-'a').to!int;

        int function(char) charToColumn=(column)=>(column-'1').to!int;

        this(Player!Camp[2] _players){
            this._players=_players;

            auto othello_coor(){
                Coordinate[] coors;
                foreach(raw;0..8){
                    foreach(column;0..8){
                        coors~=Coordinate(raw,column);
                    }
                }
                return coors;
            }
            _board=new OthelloBoard(othello_coor,OthelloBoard.Piece(Piece.empty),
                    [OthelloBoard.Square(Coordinate(3,3),OthelloBoard.Piece(Piece.white,_players[1])),
                    OthelloBoard.Square(Coordinate(3,4),OthelloBoard.Piece(Piece.black,_players[0])),
                    OthelloBoard.Square(Coordinate(4,3),OthelloBoard.Piece(Piece.black,_players[0])),
                    OthelloBoard.Square(Coordinate(4,4),OthelloBoard.Piece(Piece.white,_players[1]))]);
        }

        void print(size_t width=7){
            _board.print!(PieceToString,rawToString,columnToString)(width);
        }

        void startGame(){
            "Game start!".writeln;
            while(1){
                routine(_players[0]);
                routine(_players[1]);
            }
        }
}

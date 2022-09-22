rm *.cpp
rm *.h
cp ./start_point_with_winner/* .
cd ./test
python rm_done.py
cd ..
cp ../host/top_tandem.cpp ../host/top.cpp

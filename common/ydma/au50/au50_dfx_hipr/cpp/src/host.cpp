#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <deque>
#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <stack>
#include <string>
#include <vector>
using namespace std;

#define COST_REQ 0.8
#define LUT_RATIO 1
#define BRAM_RATIO 1
#define DSP_RATIO 1


#define TRIAL_NUM 2000000
#define MAX_ROW 7
double e=1e-16,at=0.99999999,T=1;
//  e: termination temperature
// at: derivative of temperature
//  T: initial temperature
int L = TRIAL_NUM; //L is the maximum interation number

struct tile{ //tiles
    string tile_l;
    string tile_r;
    double x_l, x_r;
    int i;  //
};


struct func{ //
    string name;
    double lut, ff, bram18, dsp2;
    int row, start, end;
    int i;  //
};

struct pragma{ //
    string name;
    double lut, ff, bram18, dsp2;
    int i;  //
};

struct tile_range{ //
	int row;
    double start, end;
};

struct res_per_tile{ //
    double lut, bram18, dsp2;
};

struct res_range{ //
	bool valid=false;
    int start, end;
};

struct connect{ //
	string src, dest;
	int i;
};



class HiPR{
public:
	vector<tile> tiles;
	vector<func> functions;
	vector<pragma> pragmas;
	vector<connect> connects;
	res_per_tile num_per_tile = {432, 22, 22};
	double lut_ratio = LUT_RATIO;
	double bram18_ratio = BRAM_RATIO;
	double dsp2_ratio = DSP_RATIO;

	void init_connect(string file_in){
		char file_in_name[file_in.size()+1];
		file_in_name[file_in.size()] =  0;
		for(int i=0; i<file_in.size(); i++){ file_in_name[i] = file_in[i]; }
		freopen(file_in_name, "r", stdin);
		int n;
		cin >> n;
		tiles.clear();

		for (int i = 0; i < n; i++) {
			connect t;
			cin >> t.src >> t.dest;
			t.i=i;
			connects.push_back(t);
		}
		fclose(stdin);
	}

	void init_tiles(string file_in){
		char file_in_name[file_in.size()+1];
		file_in_name[file_in.size()] =  0;
		for(int i=0; i<file_in.size(); i++){ file_in_name[i] = file_in[i]; }
		freopen(file_in_name, "r", stdin);
		int n;
		cin >> n;
		tiles.clear();

		for (int i = 0; i < n; i++) {
			tile t;
			cin >> t.tile_l >> t.x_l >> t.tile_r >> t.x_r;
			t.i=i;
			tiles.push_back(t);
		}
		fclose(stdin);
	}

	void init_pragma(string file_in){
		char file_in_name[file_in.size()+1];
		for(int i=0; i<file_in.size(); i++){ file_in_name[i] = file_in[i]; }
		file_in_name[file_in.size()] = 0;
		cout << file_in_name << endl;
		freopen(file_in_name, "r", stdin);
		int n;
		cin >> n;

		for (int i = 0; i < n; i++) {
			pragma t;
			cin >> t.name >> t.lut >> t.ff >> t.bram18 >> t.dsp2;
			t.i=i;
			pragmas.push_back(t);
		}
		fclose(stdin);
	}


	void init_pr(string file_in){
		char file_in_name[file_in.size()+1];
		for(int i=0; i<file_in.size(); i++){ file_in_name[i] = file_in[i]; }
		file_in_name[file_in.size()] = 0;
		cout << file_in_name << endl;
		freopen(file_in_name, "r", stdin);
		int n;
		cin >> n;
		tiles.clear();
		string dummy1;
		int dummy2;

		for (int i = 0; i < n; i++) {
			func t;
			cin >> t.name >> t.lut >> t.ff >> t.bram18 >> t.dsp2;
			t.i=i;
			functions.push_back(t);
		}
		fclose(stdin);


		for (int i = 0; i < n; i++) {
			functions[i].lut    *= pragmas[i].lut;
			functions[i].ff     *= pragmas[i].ff;
			functions[i].bram18 *= pragmas[i].bram18;
			functions[i].dsp2   *= pragmas[i].dsp2;
		}

	}

	res_range find_resource_range(string res_type, int start_tile, int end_tile){
		res_range out;
		for(int i=start_tile; i<end_tile+1; i++){
			if(tiles[i].tile_l == res_type) { out.start = tiles[i].x_l; out.valid = true; break; }
			if(tiles[i].tile_r == res_type) { out.start = tiles[i].x_r; out.valid = true; break; }
		}

		for(int i=start_tile; i<end_tile+1; i++){
			if(tiles[i].tile_l == res_type) { out.end = tiles[i].x_l; }
			if(tiles[i].tile_r == res_type) { out.end = tiles[i].x_r; }
		}
		return out;
	}


	double return_total_dest(void){
		double x1, y1;
		double x2, y2;
		double out = 0;
		for(int i=0; i<connects.size(); i++){
			for(int j=0; j<functions.size(); j++){
				if(functions[j].name == connects[i].src){
					x1 = functions[j].row;
					y1 = functions[j].start;
					//cout << connects[i].src << ": " << x1 << ", " << y1 << endl;
				}
				if(functions[j].name == connects[i].dest){
					x2 = functions[j].row;
					y2 = functions[j].start;
					//cout << connects[i].dest  << ": " << x2 << ", " << y2 << endl;
				}

			}

			out += (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
		}

		out = out/connects.size();
		//cout << "out = " << out << endl;
		return out;
	}


	tile_range find_tile_range(int start_tile, int start_row, func op, bool debug=false){
		tile_range out;
		func still_need;
		if(debug) cout << "\n======================" << op.name << endl;
		out.start = start_tile;

		still_need = op;
		still_need.lut    *= lut_ratio;
		still_need.bram18 *= bram18_ratio;
		still_need.dsp2   *= dsp2_ratio;
		int offset = 0;
		while(still_need.lut > 0 || still_need.bram18>0 || still_need.dsp2>0){

			if(debug) cout << offset << endl;
			if(tiles[start_tile+offset].tile_l == "CLB")    { still_need.lut    -= num_per_tile.lut; }
			if(tiles[start_tile+offset].tile_l == "BRAM18") { still_need.bram18 -= num_per_tile.bram18; }
			if(tiles[start_tile+offset].tile_l == "DSP2")   { still_need.dsp2   -= num_per_tile.dsp2; }
			if(tiles[start_tile+offset].tile_r == "CLB")    { still_need.lut    -= num_per_tile.lut; }
			if(tiles[start_tile+offset].tile_r == "BRAM18") { still_need.bram18 -= num_per_tile.bram18; }
			if(tiles[start_tile+offset].tile_r == "DSP2")   { still_need.dsp2   -= num_per_tile.dsp2; }
			if(debug) cout << "clb=" << still_need.lut;
			if(debug) cout << "bram2=" << still_need.bram18;
			if(debug) cout << "dsp2=" << still_need.dsp2 << endl;
			if(debug) cout << "start_tile=" << start_tile << " offset=" << offset << " start_tile+offset=" << start_tile+offset << endl;
			offset++;
			if(start_tile+offset >= tiles.size()){
				still_need = op;
				still_need.lut    *= lut_ratio;
				still_need.bram18 *= bram18_ratio;
				still_need.dsp2   *= dsp2_ratio;
				offset = 0;
				start_row++;
				if(start_row == MAX_ROW){ start_row = 0; }
				start_tile = 0;
			}


			// test for unusable oreas
			// overlapping configuration area
			if((start_row==0 || start_row==3) &&
			   (( start_tile<=68 && 68<=start_tile+offset-1) || ( start_tile<=70 && 70<=start_tile+offset-1))
			){
				still_need = op;
				still_need.lut    *= lut_ratio;
				still_need.bram18 *= bram18_ratio;
				still_need.dsp2   *= dsp2_ratio;
				offset = 0;
				start_tile = 71;
			}

			// Overlapping with firmware area
			if((start_row==2 || start_row==3) &&
			   (( start_tile<=108 && 108<=start_tile+offset-1) || ( start_tile<=125 && 125<=start_tile+offset-1))
			){
				still_need = op;
				still_need.lut    *= lut_ratio;
				still_need.bram18 *= bram18_ratio;
				still_need.dsp2   *= dsp2_ratio;
				offset = 0;
				start_row++;
				if(start_row == MAX_ROW){ start_row = 0; }
				start_tile = 0;
			}
		}

		out.row = start_row;
		out.start = start_tile;
		//out.end = start_tile+offset-1;
		if(start_tile+offset == tiles.size()){
			out.end = start_tile+offset-1;  //delibrately include one more tiles to avoid partition reduce usable IPs
		}else{
			out.end = start_tile+offset;  //delibrately include one more tiles to avoid partition reduce usable IPs
		}
		return out;
	}

	void floorplan(void){
		tile_range out;
		int start_tile = 0;
		int start_row = 0;

		for(int i=0; i<functions.size(); i++){
			out = find_tile_range(start_tile, start_row, functions[i]);
			//if(out.end > 68 && out.start <= 68){
			//	//start_row++;
			//	start_tile = 69;
			//	out = find_tile_range(start_tile, start_row, functions[i]);
			//}


			//functions[i].row   = i%7;
			start_row = out.row;
			functions[i].row   = out.row;
			//functions[i].row   = start_row;
			functions[i].start = out.start;
			functions[i].end   = out.end;
			//start_tile=0;
			//start_tile=rand()%functions.size();
			if(out.end+2 < tiles.size()){
				start_tile =  out.end+2;
			}else{
				if(out.row+1 <MAX_ROW){
					start_row = out.row+1;
				}else{
					start_row = 0;
				}
				start_tile =  0;
			}
		}
	}

	// random change the location for a function
	void reloc(int func_index){
		int start_tile=rand()%functions.size();
		int start_row=rand()%7;
		cout << "try: tile=" << start_tile << ", row=" << start_row;
		tile_range out = find_tile_range(start_tile, start_row, functions[func_index]);
		functions[func_index].row = out.row;
		functions[func_index].start = out.start;
		functions[func_index].end = out.end;
		cout << " reloc end" << endl;
	}


	double cost_function(bool debug=false){
		double cost = 0;
		vector <double> cost_table[7];
		for (int i=0; i<7; i++){
			for (int j=0; j<tiles.size(); j++){
				cost_table[i].push_back(0);
			}
		}

		for(int i=0; i<functions.size(); i++){
			for(int j=functions[i].start; j<functions[i].end+1; j++){
				cost_table[functions[i].row][j]++;
			}
		}


		// test for overlapping
		int overlap = 0;
		for(int i=0; i<7; i++){
			for(int j=0; j<tiles.size(); j++){
				if(cost_table[i][j] > 1){
					overlap = overlap + cost_table[i][j] - 1;
				}
			}
		}

		// test for unusable oreas
		int invalid_area = 0;
		for(int i=0; i<7; i++){
			for(int j=0; j<tiles.size(); j++){
				// configuration area overlap violation
				if((i==0 || i==3)&&(j>=68 && j<=70)) { if(cost_table[i][j] > 0) { invalid_area++; } }

				// firmware overlap violation
				if((i==2 || i==3)&&(j>=108 && j<=125)) { if(cost_table[i][j] > 0) { invalid_area++; } }
			}
		}



		cost = overlap+invalid_area + this->return_total_dest()*0.001;
		if(debug) cout << "overlay = " << overlap << " invalid_area=" << invalid_area << endl;
		return cost;
	}

	void SimulatedAnnealing(bool debug=false){
		vector<func> functions_backup;
		double accept = 0;
		double cost_min = 100000000;
		double cost;
		this->floorplan();
		cost_min = this->cost_function();
		if(debug) cout << "init_cost = " << this->cost_function() << endl;

		//for(int i=0; i<functions.size(); i++){ functions_backup[i] = functions[i]; }
		//for (int i=0; i<TRIAL_NUM; i++){
		while(L--){
			if(L%1000==0) cout << "L = " << L << endl;
			int func_index1 = rand()%functions.size();
			int func_index2 = rand()%functions.size();

			if(func_index1 == func_index2) { continue; }

			swap(functions[func_index1], functions[func_index2]);
			//this->print_PRs();
			if(debug) cout << "L = " << L << ": ";
			this->floorplan();
			cost = this->cost_function();


			double df = cost - cost_min;
			double sj=rand()%10000;     //sj belogs to [0 1]
			sj/=10000;


			if( (df < 0)) { // if the cost is decreased, accept the swap
				cost_min = cost;
			} else if(exp(-df/T)>sj){  //否则以一定概率接受{
				cost_min = cost;
				accept++;
			} else {
				swap(functions[func_index1], functions[func_index2]);
			}
			if(debug) cout << "cost = " << cost;
			cout << " cost_min = " << cost_min << endl;

			if(debug) this->print_seq();
			if(cost_min < COST_REQ) break;
			T*=at;  // temperature decrease
			if(T<e) break;  //Exit when temperature is small enough
		}


		cout << " cost_min = " << cost_min << endl;
		cout << "accept ratio = " << accept/TRIAL_NUM << endl;
	}



	void gen_xdc(char *file_out){
		freopen(file_out, "w", stdout);

		for(int i=0; i<functions.size(); i++){
			int start = 0;
			int end = 0;
			res_range out;
			cout << "\n\ncreate_pblock " << functions[i].name << endl;
			out = find_resource_range("CLB", functions[i].start, functions[i].end);
			if (out.valid){
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {SLICE_X";
				cout << out.start << "Y" << 65+functions[i].row*60 << ":SLICE_X" << out.end << "Y" << 119+functions[i].row*60 << "}" << endl;
			}

			out = find_resource_range("EMPTY_CLB", functions[i].start, functions[i].end);
			if (out.valid){
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {SLICE_X";
				cout << out.start << "Y" << 65+functions[i].row*60 << ":SLICE_X" << out.end << "Y" << 119+functions[i].row*60 << "}" << endl;
			}

			out = find_resource_range("DSP2", functions[i].start, functions[i].end);
			if (out.valid){
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {DSP48E2_X";
				cout << out.start << "Y" << 20+functions[i].row*24 << ":DSP48E2_X" << out.end << "Y" << 41+functions[i].row*24 << "}" << endl;
			}

			out = find_resource_range("EMPTY_DSP2", functions[i].start, functions[i].end);
			if (out.valid){
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {DSP48E2_X";
				cout << out.start << "Y" << 20+functions[i].row*24 << ":DSP48E2_X" << out.end << "Y" << 41+functions[i].row*24 << "}" << endl;
			}


			out = find_resource_range("BRAM18", functions[i].start, functions[i].end);
			if (out.valid) {
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {RAMB18_X";
				cout << out.start << "Y" << 26+functions[i].row*24 << ":RAMB18_X" << out.end << "Y" << 47+functions[i].row*24 << "}" << endl;
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {RAMB36_X";
				cout << out.start << "Y" << 13+functions[i].row*12 << ":RAMB36_X" << out.end << "Y" << 23+functions[i].row*12 << "}" << endl;
			}

			out = find_resource_range("EMPTY_BRAM18", functions[i].start, functions[i].end);
			if (out.valid) {
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {RAMB18_X";
				cout << out.start << "Y" << 26+functions[i].row*24 << ":RAMB18_X" << out.end << "Y" << 47+functions[i].row*24 << "}" << endl;
				cout << "resize_pblock [get_pblocks " << functions[i].name << "] -add {RAMB36_X";
				cout << out.start << "Y" << 13+functions[i].row*12 << ":RAMB36_X" << out.end << "Y" << 23+functions[i].row*12 << "}" << endl;
			}
			cout << "set_property SNAPPING_MODE ON [get_pblocks " << functions[i].name << "]" << endl;
			cout << "set_property IS_SOFT TRUE [get_pblocks " << functions[i].name << "]" << endl;
			cout << "add_cells_to_pblock [get_pblocks " << functions[i].name;
			cout << "] [get_cells -quiet [list level0_i/ulp/ydma_1/mono_inst/" << functions[i].name << "_inst]]" << endl;
		}
		fclose(stdout);
	}

	void print_tiles(void){
		for(int i=0; i<tiles.size(); i++){
			cout << tiles[i].i << ": " << tiles[i].tile_l << " " << tiles[i].x_l;
			cout << " " << tiles[i].tile_r << " " << tiles[i].x_r << endl;
		}

	}

	void print_PRs(void){
		for(int i=0; i<functions.size(); i++){
			cout << functions[i].i << ": " << functions[i].name << " " << functions[i].lut;
			cout << " " << functions[i].ff << " " << functions[i].bram18;
			cout << " " << functions[i].dsp2;
			cout << ": " << functions[i].row;
			cout << " "  << functions[i].start;
			cout << " "  << functions[i].end << endl;
		}
	}

	void print_connects(void){
		for(int i=0; i<connects.size(); i++){
			cout << connects[i].i << ": " << connects[i].src << "=>" << connects[i].dest << endl;
		}
	}
	void print_seq(void){
		for(int i=0; i<functions.size(); i++){ cout << functions[i].i << " "; }
		cout << endl;
	}

};

int main(int argc, char**argv) {

	string pragma_path;
	string res_req_path;
	string connect_path;
	string arch_path;


	if(argc > 1){
		string path_prefix =  argv[1];
		pragma_path  = path_prefix+"/pragma.txt";
		res_req_path = path_prefix+"/resource.txt";
		connect_path = path_prefix+"/connection.txt";
		arch_path    = path_prefix+"/in.txt";
	}else{
		pragma_path  = "./src/pragma.txt";
		res_req_path = "./src/resource.txt";
		connect_path = "./src/connection.txt";
		arch_path    = "./src/in.txt";
	}
	HiPR pr_inst;
	pr_inst.init_pragma(pragma_path);
	pr_inst.init_pr(res_req_path);
	pr_inst.init_connect(connect_path);
	pr_inst.init_tiles(arch_path);
	pr_inst.SimulatedAnnealing();

	pr_inst.print_PRs();
	//pr_inst.print_connects();
	//pr_inst.print_tiles();
	pr_inst.return_total_dest();
	pr_inst.gen_xdc("src/floorplan.xdc");
	//pr_inst.gen_xdc("/home/ylxiao/ws_211/PR_vitis/rendering/hw_dfx_manual/xdc/sub.xdc");
	cout << "done" << endl;
    return 0;
}


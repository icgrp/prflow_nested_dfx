// find pixels in the triangles from the bounding box
void rasterization2_odd (
        hls::stream<ap_uint<32> > & Input_1,
        hls::stream<ap_uint<32> > & Output_1,
        hls::stream<ap_uint<32> > & Output_2
        )
{
#pragma HLS INTERFACE ap_hs port=Input_1
#pragma HLS INTERFACE ap_hs port=Output_1
#pragma HLS INTERFACE ap_hs port=Output_2
  #pragma HLS INLINE off
    bit16 i = 0;
    bit16 i_top = 0;
    bit16 i_bot = 0;
    int y_tmp;
    int j;
    Triangle_2D triangle_2d_same;
    bit2 flag;
    bit8 max_min[5];
    bit16 max_index[1];
    bit32 out_tmp;
    static CandidatePixel fragment[500];

    bit32 tmp = Input_1.read();
    flag = (bit2) tmp(1,0);
    triangle_2d_same.x0(7, 0)=tmp(15,8);
    triangle_2d_same.y0(7, 0)=tmp(23,16);
    triangle_2d_same.x1(7, 0)=tmp(31,24);

    tmp = Input_1.read();
    triangle_2d_same.y1(7, 0)=tmp(7,0);
    triangle_2d_same.x2(7, 0)=tmp(15,8);
    triangle_2d_same.y2(7, 0)=tmp(23,16);
    triangle_2d_same.z(7, 0)=tmp(31,24);

    tmp = Input_1.read();
    max_index[0](15, 0)=tmp(15,0);
    max_min[0](7, 0)=tmp(23,16);
    max_min[1](7, 0)=tmp(31,24);

    tmp = Input_1.read();
    max_min[2](7, 0)=tmp(7,0);
    max_min[3](7, 0)=tmp(15,8);
    max_min[4](7, 0)=tmp(23, 16);
#ifdef PROFILE
    rasterization2_m_in_1+=4;
#endif

  // clockwise the vertices of input 2d triangle
  if ( flag )
  {
      Output_1.write(i_top);
      Output_2.write(i_bot);
#ifdef PROFILE
        rasterization2_m_out_1++;
        rasterization2_m_out_2++;
#endif
    return;
  }
  bit8 color = 100;


  RAST2: for ( bit16 k = 0; k < max_index[0]; k++ )
  {
    #pragma HLS PIPELINE II=1
    bit8 x = max_min[0] + k%max_min[4];
    bit8 y = max_min[2] + k/max_min[4];

    if( pixel_in_triangle( x, y, triangle_2d_same ) )
    {
      fragment[i].x = x;
      fragment[i].y = y;
      fragment[i].z = triangle_2d_same.z;
      fragment[i].color = color;
      i++;
      if(y>127) i_top++;
      else i_bot++;
    }
  }

  Output_1.write(i_top);
  Output_2.write(i_bot);
#ifdef PROFILE
        rasterization2_m_out_1++;
        rasterization2_m_out_2++;
#endif
  for(j=0; j<i; j++){
#pragma HLS PIPELINE II=1
      out_tmp(7, 0) = fragment[j].x;
      out_tmp(15, 8) = fragment[j].y;
      y_tmp = (int) out_tmp(15, 8);
      out_tmp(23, 16) = fragment[j].z;
      out_tmp(31, 24) = fragment[j].color;
      if( y_tmp > 127){
          Output_1.write(out_tmp);
#ifdef PROFILE
        rasterization2_m_out_1++;
#endif
      }
      else
      {
          Output_2.write(out_tmp);
#ifdef PROFILE
        rasterization2_m_out_2++;
#endif
      }
  }

  return;
}
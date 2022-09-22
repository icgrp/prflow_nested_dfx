// calculate bounding box for a 2D triangle
void rasterization1_even_m (
        Triangle_2D triangle_2d,
        hls::stream<ap_uint<32> > & Output_1)
{
    Triangle_2D triangle_2d_same;
    static bit8 max_min[5]={0, 0, 0, 0, 0};
    static bit16 max_index[1]={0};


  #pragma HLS INLINE off
  // clockwise the vertices of input 2d triangle
  if ( check_clockwise( triangle_2d ) == 0 ){
    bit32 tmp;
    tmp(7,0) = 1;
    tmp(15, 8) = triangle_2d_same.x0;
    tmp(23,16) = triangle_2d_same.y0;
    tmp(31,24) = triangle_2d_same.x1;
    Output_1.write(tmp);

    tmp(7,0) = triangle_2d_same.y1;
    tmp(15, 8) = triangle_2d_same.x2;
    tmp(23,16) = triangle_2d_same.y2;
    tmp(31,24) = triangle_2d_same.z;
    Output_1.write(tmp);

    tmp(15,0) = max_index[0];
    tmp(23,16) = max_min[0];
    tmp(31,24) = max_min[1];
    Output_1.write(tmp);

    tmp(7,0) = max_min[2];
    tmp(15, 8) = max_min[3];
    tmp(23,16) = max_min[4];
    tmp(31,24) = 0;
    Output_1.write(tmp);
#ifdef PROFILE
  data_redir_m_out_2+=4;
#endif

    return;
  }
  if ( check_clockwise( triangle_2d ) < 0 )
    clockwise_vertices( &triangle_2d );




  // copy the same 2D triangle
  triangle_2d_same.x0 = triangle_2d.x0;
  triangle_2d_same.y0 = triangle_2d.y0;
  triangle_2d_same.x1 = triangle_2d.x1;
  triangle_2d_same.y1 = triangle_2d.y1;
  triangle_2d_same.x2 = triangle_2d.x2;
  triangle_2d_same.y2 = triangle_2d.y2;
  triangle_2d_same.z  = triangle_2d.z ;

  // find the rectangle bounds of 2D triangles
  max_min[0] = find_min( triangle_2d.x0, triangle_2d.x1, triangle_2d.x2 );
  max_min[1] = find_max( triangle_2d.x0, triangle_2d.x1, triangle_2d.x2 );
  max_min[2] = find_min( triangle_2d.y0, triangle_2d.y1, triangle_2d.y2 );
  max_min[3] = find_max( triangle_2d.y0, triangle_2d.y1, triangle_2d.y2 );
  max_min[4] = max_min[1] - max_min[0];

  // calculate index for searching pixels
  max_index[0] = (max_min[1] - max_min[0]) * (max_min[3] - max_min[2]);
  bit32 tmp;
  tmp(7,0) = 0;
  tmp(15, 8) = triangle_2d_same.x0;
  tmp(23,16) = triangle_2d_same.y0;
  tmp(31,24) = triangle_2d_same.x1;
  Output_1.write(tmp);

  tmp(7,0) = triangle_2d_same.y1;
  tmp(15, 8) = triangle_2d_same.x2;
  tmp(23,16) = triangle_2d_same.y2;
  tmp(31,24) = triangle_2d_same.z;
  Output_1.write(tmp);

  tmp(15,0) = max_index[0];
  tmp(23,16) = max_min[0];
  tmp(31,24) = max_min[1];
  Output_1.write(tmp);

  tmp(7,0) = max_min[2];
  tmp(15, 8) = max_min[3];
  tmp(23,16) = max_min[4];
  tmp(31,24) = 0;
  Output_1.write(tmp);
#ifdef PROFILE
  data_redir_m_out_2+=4;
#endif
  return;
}
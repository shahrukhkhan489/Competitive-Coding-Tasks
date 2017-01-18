import java.io.BufferedReader;
import java.io.InputStreamReader;

class TestClass {
	
    public static void main(String args[] ) throws Exception {
  
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line = br.readLine();
        int T = Integer.parseInt(line);
        int N,max,min,sum;
        int[] A = new int[100000];
        
        for (int iteration=0;iteration<T;iteration++)
        {
        	sum=0;
        	N = Integer.parseInt(line);
        	for (int i = 0; i < N; i++) 
        	{
    	    	A[i] = (int)System.in.read();
        	}
	        for (int j=0;j<N;j++)
	        {
	        	for (int k = j; k < N; k++) 
	        	{
	    	    	if( maximumValue(A, j, k) == minimumValue(A, j, k) )
	    	    		sum++;	
	        	}
	        }
	        System.out.println(sum);
        }
        
    }

	public static int maximumValue(int[] array, int A, int B) {
		
	     int max = array[(int)A];       // start with max = first element
	
	     for(int i = (int)A+1; i<(int)B; i++)
	     {
	     	 System.out.println(array[i]);
	          if(array[i] > max)
	                max = array[i];
	     }
	     return max;                // return highest value in array
	}

	public static int minimumValue(int[] array, int A, int B) {

	     int min = array[(int)A];       // start with max = first element
	
	     for(int i = (int)A+1; i<(int)B; i++)
	     {
	          if(array[i] < min)
	                min = array[i];
	     }
	     return min;                // return highest value in array
	}


}

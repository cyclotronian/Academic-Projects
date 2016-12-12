import java.io.*;
import java.util.*;

public class SchedulingAlgo
{
	private Vector<Request> requestsAtSameTime;		//To hold batch requests coming at an instance in time
	private Vector<Request> allRequests;			//To hold all requests 
	private int totalNoOfHeads;						//Total number of possible heads, calculated from disk parameter 
	private int tracksPerSurface;					//Total number of possible tracks, calculated from disk parameter
	private int sectorsPerTrack;					//Total number of possible sectors, calculated from disk parameter
	private int RPM;								//Rotation per minute, given as disk parameter 
	private int seekRate;							//seek rate, given as disk parameter 
	private float R;								//R value for VSCAN algorithm 
	static Request previousRequest;					//To hold the previous request 
	static Properties _prop;						//To get input from file
	
	public static void main(String args[]) throws IOException
	{
		_prop= new Properties();
		String fileName = "input.conf";
		InputStream is = new FileInputStream(fileName);
		_prop.load(is);
		SchedulingAlgo sstf=new SchedulingAlgo();
		sstf.initialize();
		sstf.simulateSSTF();
		SchedulingAlgo vscan=new SchedulingAlgo();
		vscan.initialize();
		vscan.simulateVSCAN();
	}
	
	//Initializing all requests and initial position
	public void initialize()
	{
		totalNoOfHeads = Integer.parseInt(_prop.getProperty("heads"));
		tracksPerSurface = Integer.parseInt(_prop.getProperty("tracks"));
		sectorsPerTrack = Integer.parseInt(_prop.getProperty("sectors"));
		RPM = Integer.parseInt(_prop.getProperty("RPM"));
		seekRate = Integer.parseInt(_prop.getProperty("seekRate"));
		R = Float.parseFloat(_prop.getProperty("R"));
		previousRequest.LBN=Integer.parseInt(_prop.getProperty("LBN0"));
		previousRequest.priority = Integer.parseInt(_prop.getProperty("priority0"));
		previousRequest.head = previousRequest.LBN / (sectorsPerTrack*tracksPerSurface);
		previousRequest.track = (previousRequest.LBN - sectorsPerTrack*tracksPerSurface*previousRequest.head) / (sectorsPerTrack);
		previousRequest.sector = (previousRequest.LBN - sectorsPerTrack*tracksPerSurface*previousRequest.head) % sectorsPerTrack;
		previousRequest.requestTime=Float.parseFloat(_prop.getProperty("requestTime0"));
		for(int i=1;i<=Integer.parseInt(_prop.getProperty("NoOfRequest"));i++)
		{
			Request req=new Request();
			req.LBN=Integer.parseInt(_prop.getProperty("LBN"+i));
			req.priority = Integer.parseInt(_prop.getProperty("priority"+i));
			req.head = req.LBN / (sectorsPerTrack*tracksPerSurface);
			req.track = (req.LBN - sectorsPerTrack*tracksPerSurface*req.head) / (sectorsPerTrack);
			req.sector = (req.LBN - sectorsPerTrack*tracksPerSurface*req.head) % sectorsPerTrack;
		 	req.requestTime=Float.parseFloat(_prop.getProperty("requestTime"+i));
		 	allRequests.add(req);
		}
	}
	
	//Default Constructor
	public SchedulingAlgo()
	{
		allRequests=new Vector<Request>();
		requestsAtSameTime=new Vector<Request>();
		totalNoOfHeads=0;
		tracksPerSurface=0;
		sectorsPerTrack=0;
		RPM=0;
		seekRate=0;
		previousRequest=new Request();  
	}
	
	//Checking validity of the request
	private boolean valid(Request req)
	{
		if (req.track>=tracksPerSurface || req.sector>=sectorsPerTrack || req.head>=totalNoOfHeads)
			return(false);                       
		if(previousRequest!=null && previousRequest.requestTime > req.requestTime)
			return(false);
		return(true);   
	}
	
	//SSTF_LBN simulation 
	public void simulateSSTF() throws IOException
	{
		float currentTime=0;
		int currentTrack=0;
		int currentSector=0;
		int distance=0;
		int reads=0;
		float latency=0;
		float readTime=0;
		int currentLBN=previousRequest.LBN;
		FileWriter fw=new FileWriter("SSTF.out");
		fw.write("Total: [ #Track = "+tracksPerSurface+", #Sector = "+sectorsPerTrack+", #Head = "+totalNoOfHeads+"]"+"\n");
		fw.write("Starting heads at [LBN = "+previousRequest.LBN+", Track = "+previousRequest.track+", Sector = "+previousRequest.sector+", Head = "+previousRequest.head+"]"+"\n");
		int index=0;
		int i;
		Request req=new Request();
		while (!requestsAtSameTime.isEmpty()|| index<allRequests.size())
		{
			if (requestsAtSameTime.isEmpty())
			{
				req=(Request)allRequests.elementAt(index);
				currentTime=req.requestTime;
				index++;
				if (valid(req))
				{
					previousRequest=req;
					requestsAtSameTime.addElement(req);
					fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"]"+"\n");
				}       
				else
				{
					fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"] Invalid Request"+"\n");
				}
				while (index<allRequests.size())
				{
					req=(Request)allRequests.elementAt(index);
					if(req.requestTime>currentTime)
						break;
					else
					{
						index++;
						if (valid(req))
						{
							previousRequest=req;
							requestsAtSameTime.addElement(req);
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"] \n");
						}       
						else
						{
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"] Invalid Request"+"\n");
						}
					}               
				}
			}
			else
			{
				reads++;
				int minLBN=Integer.MAX_VALUE;
				int tempIndex=0;
				for(i=0;i<requestsAtSameTime.size();i++)
				{
					req=(Request)requestsAtSameTime.elementAt(i);
					if (Math.abs(req.LBN-currentLBN)<minLBN)
					{
						minLBN=Math.abs(req.LBN-currentLBN);
						tempIndex=i;
					}
				}
				req=(Request)requestsAtSameTime.remove(tempIndex);
				fw.write("Move Head to : [LBN = "+req.LBN+", Track = "+req.track+",Sector = "+req.sector+", Head = "+req.head+"]\n");
				float seekDistance=(float)Math.abs(currentTrack-req.track);
				float LBNDistance=(float)Math.abs(currentLBN-req.LBN);
				distance+=LBNDistance;
				currentTrack=req.track;
				currentLBN=req.LBN;
				currentTime+=(float)seekDistance/seekRate;
				currentSector=(int)(sectorsPerTrack*RPM/60*seekDistance/seekRate+currentSector)%sectorsPerTrack;
				if (currentSector>req.sector)
				{
					latency+=(float)(sectorsPerTrack-currentSector+req.sector)*60/sectorsPerTrack/RPM;
					currentTime+=(float)(sectorsPerTrack-currentSector+req.sector)*60/sectorsPerTrack/RPM;
				}
				else
				{
					latency+=(float)(req.sector-currentSector)*60/sectorsPerTrack/RPM;  
					currentTime+=(float)(req.sector-currentSector)*60/sectorsPerTrack/RPM;
				}
				readTime+=currentTime-req.requestTime;
				currentSector=req.sector;
				fw.write("Process Read : [LBN = "+req.LBN+", Track = "+req.track+",Sector = "+req.sector+", Head = "+req.head+"]"+"\n");
				while (index<allRequests.size())
				{
					req=(Request)allRequests.elementAt(index);
					if(req.requestTime>currentTime)
						break;
					else
					{
						index++;
						if (valid(req))
						{
							previousRequest=req;
							requestsAtSameTime.addElement(req);
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"] \n");
						}       
						else
						{
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"] Invalid Request\n");
						}
					}               
				}
			}
		}
		fw.write("Total number of Reads:"+reads+"\n");
		fw.write("Total distance traveled:"+distance+"\n");
		if(reads==0)
		{
			fw.write("No Read Request\n");
		}
		else
		{               
			fw.write("Average Seek time:"+(float)distance/seekRate/reads+" seconds"+"\n");
			fw.write("Average latency:"+latency/reads+" seconds"+"\n");
			fw.write("Average total read time:"+readTime/reads+" seconds"+"\n");
		}
		fw.close();
	}
	
	
	//VSCAN Algorithm
	public void simulateVSCAN() throws IOException
	{
		float currentTime=0;
		int currentTrack=0;
		int currentSector=0;
		int distance=0;
		int reads=0;
		float latency=0;
		float readTime=0;
		int currentLBN=previousRequest.LBN;
		FileWriter fw=new FileWriter("VSCAN.out");
		int index=0;
		int i;
		Request req=new Request();
		fw.write("Total: [ #Track = "+tracksPerSurface+", #Sector = "+sectorsPerTrack+", #Head = "+totalNoOfHeads+"]"+"\n");
		fw.write("Starting heads at [LBN = "+previousRequest.LBN+", Track = "+previousRequest.track+", Sector = "+previousRequest.sector+", Head = "+previousRequest.head+"]"+"\n");
		while (!requestsAtSameTime.isEmpty()|| index<allRequests.size())
		{
			//Add all the batch requests at current time to 'requestsAtSameTime' vector
			if (requestsAtSameTime.isEmpty())
			{
				
				req=(Request)allRequests.elementAt(index);
				currentTime=req.requestTime;
				index++;
				if (valid(req))
				{
					previousRequest=req;
					requestsAtSameTime.addElement(req);
					fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"]"+"\n");
				}       
				else
				{
					fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"] Invalid Request"+"\n");
			
				}
				while (index<allRequests.size())
				{
					req=(Request)allRequests.elementAt(index);
					if(req.requestTime>currentTime)
						break;
					else
					{
						index++;
						if (valid(req))
						{
							previousRequest=req;
							requestsAtSameTime.addElement(req);
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"]"+"\n");
						}       
						else
						{
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"] Invalid Request"+"\n");
						}
					}               
				}
			}
			//Process all the current time batch requests from 'requestsAtSameTime' vector
			else
			{
				reads++;
				float minLBN_Diff=Float.MAX_VALUE;
				int minPriority=Integer.MAX_VALUE;
				int tempIndex=0;
				for(i=0;i<requestsAtSameTime.size();i++)
				{
					req=(Request)requestsAtSameTime.elementAt(i);
					if(req.priority < minPriority)
					{
						minPriority=req.priority;
					}
				}
				ArrayList<Request> minPriorityRequest=new ArrayList<Request>();
				for(i=0;i<requestsAtSameTime.size();i++)
				{
					req=(Request)requestsAtSameTime.elementAt(i);
					if(req.priority == minPriority)
					{
						minPriorityRequest.add(req);
						requestsAtSameTime.remove(i);
						i--;
					}
				}
				while(!minPriorityRequest.isEmpty())
				{
					tempIndex = 0;
					for(i=0;i<minPriorityRequest.size();i++)
					{
						req=(Request)minPriorityRequest.get(i);
						if (  (((req.LBN-currentLBN) > 0)?(req.LBN-currentLBN):((currentLBN - req.LBN)+tracksPerSurface*R)) < minLBN_Diff)
						{
							if(req.LBN-currentLBN > 0)
								minLBN_Diff=Math.abs(req.LBN-currentLBN);
							else
								minLBN_Diff=Math.abs(currentLBN - req.LBN)+tracksPerSurface*R;
							tempIndex=i;
						}
					}
					req=(Request)minPriorityRequest.remove(tempIndex);
					fw.write("Move head to : [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"]\n");
					float seekDistance=(float)Math.abs(currentTrack-req.track);
					float LBNDistance=(float)Math.abs(currentLBN-req.LBN);
					distance+=LBNDistance;
					currentTrack=req.track;
					currentTime+=(float)seekDistance/seekRate;
					currentSector=(int)(sectorsPerTrack*RPM/60*seekDistance/seekRate+currentSector)%sectorsPerTrack;
					if (currentSector>req.sector)
					{
						latency+=(float)(sectorsPerTrack-currentSector+req.sector)*60/sectorsPerTrack/RPM;
						currentTime+=(float)(sectorsPerTrack-currentSector+req.sector)*60/sectorsPerTrack/RPM;
					}
					else
					{
						latency+=(float)(req.sector-currentSector)*60/sectorsPerTrack/RPM;  
						currentTime+=(float)(req.sector-currentSector)*60/sectorsPerTrack/RPM;
					}
					readTime+=currentTime-req.requestTime;
					currentSector=req.sector;
					currentLBN=req.LBN;
					fw.write("Process Read : [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+"]\n");
				}
				while (index<allRequests.size())
				{
					req=(Request)allRequests.elementAt(index);
					if(req.requestTime>currentTime)
						break;
					else
					{
						index++;
						if (valid(req))
						{
							previousRequest=req;
							requestsAtSameTime.addElement(req);
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"]"+"\n");
						}       
						else
						{
							fw.write("Read request arrived: [LBN = "+req.LBN+", Track = "+req.track+", Sector = "+req.sector+", Head = "+req.head+", Priority = "+req.priority+"] Invalid Request"+"\n");
						}
					}               
				}
			}
		}
		fw.write("Total number of Reads:"+reads+"\n");
		fw.write("Total distance traveled:"+distance+"\n");
		if(reads==0)
		{
			fw.write("No read Request");
		}
		else
		{    
			fw.write("Average Seek time:"+(float)distance/seekRate/reads+" seconds"+"\n");
			fw.write("Average latency:"+latency/reads+" seconds"+"\n");
			fw.write("Average total read time:"+readTime/reads+" seconds"+"\n");
		}
		//System.out.println("-----------------------------------------------------");
	
		fw.close();
	}
}


class Request{

	int track;
	int sector;
	int head;
	int LBN;
	int priority;
	float requestTime;
	
	public String toString()
	{
		return "Track = "+track+"\tSector = "+sector+"\tLBN = "+LBN+"\tpriority = "+priority+"\trequestTime = "+requestTime+"\n";
	}

}
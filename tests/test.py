import sys
import torch
import frnn
import numpy as np
from pytorch3d.ops.knn import knn_points

file=sys.argv[1]
radius=float(sys.argv[2])
knn=int(sys.argv[3])
device=int(sys.argv[4])
print("K:", knn, " r:", radius)

pc = []
with open(file, 'rt') as f:
    for line in f.readlines():
        pc.append([float(v) for v in line.split(',')])
pc = np.array([pc])

with torch.cuda.device(device):
  upload_start = torch.cuda.Event(enable_timing=True)
  upload_end = torch.cuda.Event(enable_timing=True)
  upload_start.record()
  pc = torch.cuda.FloatTensor(pc)
  upload_end.record()
  torch.cuda.synchronize()
  print("Upload data time: ", upload_start.elapsed_time(upload_end))  # milliseconds

  start = torch.cuda.Event(enable_timing=True)
  end = torch.cuda.Event(enable_timing=True)
  start.record()
  _ = frnn.frnn_grid_points(pc, pc, lengths1=None, lengths2=None, K=knn, r=radius, radius_cell_ratio=2)
  end.record()
  torch.cuda.synchronize()
  print("FRNN search time: ", start.elapsed_time(end))  # milliseconds

  #_ = knn_points(pc, pc, lengths1=None, lengths2=None, K=knn, version=-1, return_nn=True, return_sorted=True)
  #end.record()
  #torch.cuda.synchronize()
  #print("PyTorch3d search time: ", start.elapsed_time(end))  # milliseconds

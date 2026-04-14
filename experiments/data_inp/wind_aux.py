# wind.depth - all ones, 1152x576, read top to bottom (IDLA=3)
import numpy as np
data = np.ones((576, 1152), dtype=int)
np.savetxt('wind.depth', data, fmt='%d')
np.savetxt('ice.depth', data, fmt='%d')

# wind.mask - same
np.savetxt('wind.mask', data, fmt='%d')
np.savetxt('ice.mask', data, fmt='%d')

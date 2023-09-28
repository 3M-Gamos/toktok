
def removeDuplicates(self, nums):
    """
    :type nums: List[int]
    :rtype: int
    """
    dic ={}
    l=nums[:]
    for i, num in enumerate(l)  :
            dic[num]=i
    for key in dic  :
        k=0
        l=[]
        l=l+[key]
        k=k+1
    nums= l
            
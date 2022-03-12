

--event with same uid overrides parent 
thing:event_add('test_event1','test0',function(self)
    print('tex',self)
end) 
person:event_add('test_event1','test0',function(self,a,b,c)
    print(self,a,b,c)
end)



--event with different uid does not override anything 
thing:event_add('test_event2','test0',function(self)
    print('tex',self)
end)
person:event_add('test_event2','test1',function(self,a,b,c)
    print(self,a,b,c)
end)


print('test event 1')
no_one:event_call('test_event1','hey!')

print('test event 2')
no_one:event_call('test_event2','hey!')

local ok='ok!'

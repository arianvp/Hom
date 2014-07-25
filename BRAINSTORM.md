# This file is my brainstorm file where I'm going to write down my thought stream.


basically we want something like  https://github.com/Matt-Esch/virtual-dom

https://gist.github.com/Raynos/8414846 is a gist that lead to virtual-dom. with good explanations about the arch.


We will have two threads:

* an event dispatch thread on which we dispatch async events that will modify our State MVar.

* a render thread which blocks on the State MVar until it sees a change.  the MVar is a state-change witness here. So we know that that our state has changed if and only if we can take from the MVar. 

  We then render a virtual dom with this new state and diff it against our old one. We retreive a list of 'patches' that instruct how
  we must modify the real DOM to execute this diff most efficiently.  diffing tree is an O(n^3) problem but which can be approximated using
  heuristics pretty well. I'm just gonna re-use virtual-dom for this because although really interesting to write such an algorithm in haskell,
  it's way out of my current abilities. 
  


we want the virtual dom to be a "pure" function.  so event handlers are just simple functions from state to state.
how they are actually handeld and dispatched is upto the event dispatch thread. we as render thread ignore the fact that
they are async or anything. it's not our responsibility.
  
    
    type EventCB state = EventData -> state -> state
    
    a := b = (a,b)
    type Prop = (JSString, JSString)
    type CB a= (JSString, EventCB a)
    
    -- creates a virtual domNode
    vnode :: JSString -> [Prop] -> [CB state] -> [VNode] -> VNode
    
    -- a simple counter widget might look like this:
    
    counterWidget count =
      vnode "div" [] []
        vnode "div" ["class":="boldText"] [] [ vtext . show $ count ]
        vnode "button" [] [["onClick" := const (+1)] [ vtext "increase!"]
        
    
    
... to becontinued.


what I need to do is interpret the DOM in the event-dispatch-thread as well to change these "pure state transitions" to effects on the state MVar.  That way the render-thread witnesses a state-change and will update the DOM by diffing.
    


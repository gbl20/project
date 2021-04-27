const tagsview = {
   state: {
     excludeAlive: '',
     visitedviews: []
   },
   mutations: {
     SAVE_VISITED_VIEWS: (state, value) => {
       state.visitedviews = value;
     },
     DELALL_VISITED_VIEWS: (state) => {
       state.visitedviews = [];
     },
     ADD_VISITED_VIEWS: (state, view) => {
       if (state.visitedviews.some(v => v.path == view.path)) return;
       state.excludeAlive = '';
       state.visitedviews.push({
         name: view.name,
         path: view.path,
         title: view.meta.title || 'no title',
         trueClose: view.meta.trueClose || true
       })
     },
     DEL_VISITED_VIEWS: (state, view) => {
       for (let [i, v] of state.visitedviews.entries()) {
         if (v.path == view.path) {
           if(v.trueClose) state.excludeAlive = v.name;
           state.visitedviews.splice(i, 1)
           break
         }
       }
     }
   },
   actions: {
     addVisitedViews({
       commit
     }, view) {
       commit('ADD_VISITED_VIEWS', view)
     },
     delVisitedViews({
       commit,
       state
     }, view) {
       return new Promise((resolve) => {
         commit('DEL_VISITED_VIEWS', view);
         resolve([...state.visitedviews]);
       })
     }
   }
 }
 export default tagsview

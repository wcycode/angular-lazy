module = angular.module 'angular.lazy.state',['ng','ui.router','angular.lazy.require']
# decorator $stateProvider.state
module.config(['$stateProvider','$fileLoadProvider',($stateProvider,$fileLoadProvider)->
  registerState = $stateProvider.state
  #overflow register
  $stateProvider.state = (name,config)->
    
    if config.requirejs 
      jsRequire = config.requirejs
    else 
      jsRequire = $fileLoadProvider.findRequire(name)

    if jsRequire and (resolve = config.resolve || {})
      angular.forEach(jsRequire,(v,k)->
        resolve["loadJSFile#{k}"] = ()->
          return $fileLoadProvider.getFile(v,name)
        return
      ) 
      config.resolve = resolve
    return registerState.apply(this,arguments)
])
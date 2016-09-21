import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import hudson.security.ACL;
import hudson.slaves.*;
import static java.util.Collections.singletonList;
import com.github.kostyasha.yad.commons.*;
import com.github.kostyasha.yad.DockerCloud;
import com.github.kostyasha.yad.DockerContainerLifecycle;
import com.github.kostyasha.yad.DockerSlaveTemplate;
import com.github.kostyasha.yad.launcher.DockerComputerJNLPLauncher;
import com.github.kostyasha.yad.strategy.DockerOnceRetentionStrategy;

// In Jenkins copy/paste this script into the Scriptler interface. 
// Add three parameters:
//		cloudName
//		label

// Let's find the cloud!
def myCloud = Jenkins.instance.getInstance().getCloud(cloudName);

if (!myCloud) {
  println("Cloud not found, aborting.") 
  return false
}

def templates = myCloud.getTemplates();

// templates.each { template ->
//   println "labelString: ${template.labelString}";
//   //def test = template.getLabelString();
//   //println "test: ${test}"
// }

def uniqueLabels = []
//def template_label_map = [:]
templates.each { template ->
 words = template.labelString.split()
 def labelListForSlave = []
 words.each() {
          //labelListForSlave.add(it);
          uniqueLabels.add(it)
 }
 //template_label_map.put("TEMPLATE", labelListForSlave)
}
// uniqueLabels.unique()

// uniqueLabels.each { test ->
//   println "test: ${test}";
// }

return uniqueLabels
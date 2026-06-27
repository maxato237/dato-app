allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Workaround for old plugins (e.g. isar_flutter_libs 3.1.0+1) that declare a
    // `package` in AndroidManifest.xml but no `namespace`, which AGP 8+ requires.
    // Inject the manifest package as the namespace when one is missing. Must be
    // registered before evaluationDependsOn(":app") so the project is not yet
    // evaluated when afterEvaluate is added.
    afterEvaluate {
        val androidExt = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        androidExt?.let { ext ->
            if (ext.namespace == null) {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val packageName =
                        Regex("package=\"(.+?)\"").find(manifestFile.readText())?.groupValues?.get(1)
                    if (packageName != null) {
                        ext.namespace = packageName
                    }
                }
            }
            ext.compileSdkVersion(36)
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

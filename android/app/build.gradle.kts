plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.zhangqing.games.slidingpuzzle"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.qingcoo.games.sliding_puzzle.sliding_puzzle"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        versionCode = 5
    }

    signingConfigs {
        create("release") {
            storeFile = file(findProperty("MYAPP_RELEASE_STORE_FILE") ?: "keystore/zhangqing")
            storePassword = findProperty("MYAPP_RELEASE_STORE_PASSWORD") ?: ""
            keyAlias = findProperty("MYAPP_RELEASE_KEY_ALIAS") ?: ""
            keyPassword = findProperty("MYAPP_RELEASE_KEY_PASSWORD") ?: ""

        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // Enable code shrinking for release builds
            isShrinkResources = true // Also shrink resources
            proguardFiles(getDefaultProguardFile("proguard-defaults.txt"), "proguard-rules.pro")
        }
        debug {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
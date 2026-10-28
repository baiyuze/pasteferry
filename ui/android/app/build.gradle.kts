plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.pasteferry.app"
    // Android 9 起；target 36 不用申请 Android 17 的局域网权限
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.pasteferry.app"
        minSdk = 28
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // 只出 arm64，原因见 scripts/build-android.sh；x86_64 的模拟器经 ARM 转译运行
        ndk { abiFilters += listOf("arm64-v8a") }
    }

    buildTypes {
        release {
            // 发版签名密钥还没生成（phone-task.md C6），先用调试密钥，只给内测
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    testOptions {
        unitTests.isIncludeAndroidResources = true
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Go 核心，由 scripts/build-android.sh 用 gomobile bind 生成，不进版本库
    implementation(files("libs/pasteferry-core.aar"))
    implementation("androidx.core:core-ktx:1.17.0")
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.robolectric:robolectric:4.16.1")
}

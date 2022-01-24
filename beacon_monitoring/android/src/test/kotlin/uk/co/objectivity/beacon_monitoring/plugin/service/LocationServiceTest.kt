// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.Manifest
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.hamcrest.CoreMatchers.`is`
import org.junit.Assert.assertThat
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.mockito.Mockito.*
import uk.co.objectivity.beacon_monitoring.plugin.model.LocationPermission
import java.io.Serializable

private const val REQUEST_CODE_PERMISSION = 7250

@RunWith(Parameterized::class)
class LocationServiceCheckPermissionTest(
        private val qOrAbove: Boolean,
        private val fineLocationGranted: Boolean,
        private val result: LocationPermission
) {
    private val buildVersionProvider = mock(BuildVersionProvider::class.java)
    private val permissionService = mock(PermissionService::class.java)
    private val locationEnabledService = mock(LocationEnabledService::class.java)

    private val locationService = LocationService(buildVersionProvider, permissionService, locationEnabledService)

    companion object {
        @JvmStatic
        @Parameterized.Parameters
        fun data(): Collection<Array<Any>> {
            return listOf(
                    arrayOf(true, false, LocationPermission.DENIED),
                    arrayOf(false, false, LocationPermission.DENIED),
                    arrayOf(false, true, LocationPermission.ALWAYS),
                    arrayOf(true, true, LocationPermission.WHILE_IN_USE)
            )
        }
    }

    @Test
    fun shouldReturnDeniedPermission() {
        `when`(buildVersionProvider.isQOrAbove()).thenReturn(qOrAbove)
        `when`(permissionService.isGranted(Manifest.permission.ACCESS_FINE_LOCATION))
                .thenReturn(fineLocationGranted)

        val result = locationService.checkPermission()

        assertThat(result, `is`(this.result))
    }
}

@RunWith(Parameterized::class)
class LocationServiceRequestPermissionTest(
        private val qOrAbove: Boolean,
        private val permissions: Array<String>,
        private val requestResults: IntArray,
        private val requestResult: Boolean,
        private val resultRequestCode: Int
) {
    private val buildVersionProvider = mock(BuildVersionProvider::class.java)
    private val permissionService = mock(PermissionService::class.java)
    private val locationEnabledService = mock(LocationEnabledService::class.java)

    private val locationService = LocationService(buildVersionProvider, permissionService, locationEnabledService)

    companion object {
        @JvmStatic
        @Parameterized.Parameters
        fun data(): Collection<Array<out Any>> {
            return listOf(
                    createQOrAboveParameters(0, 0, true),
                    createQOrAboveParameters(-1, 0, false),
                    createQOrAboveParameters(0, -1, false),
                    createQOrAboveParameters(-1, -1, false),
                    createBeforeQParameters(0, true),
                    createBeforeQParameters(-1, false),
                    createOtherRequestCodeParameters()
            )
        }

        private fun createQOrAboveParameters(requestResult1: Int, requestResult2: Int, requestResult: Boolean): Array<Serializable> {
            return arrayOf(
                    true,
                    arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    ),
                    intArrayOf(requestResult1, requestResult2),
                    requestResult,
                    REQUEST_CODE_PERMISSION
            )
        }

        private fun createBeforeQParameters(requestResult1: Int, requestResult: Boolean): Array<Serializable> {
            return arrayOf(
                    false,
                    arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION
                    ),
                    intArrayOf(requestResult1),
                    requestResult,
                    REQUEST_CODE_PERMISSION
            )
        }

        private fun createOtherRequestCodeParameters(): Array<Serializable> {
            return arrayOf(
                    true,
                    arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    ),
                    intArrayOf(0, 0),
                    false,
                    10
            )
        }
    }

    @Test
    fun shouldRequestLocationPermission() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)
        val activity = mock(Activity::class.java)

        locationService.bind(activityPluginBinding)
        `when`(activityPluginBinding.activity).thenReturn(activity)
        `when`(buildVersionProvider.isQOrAbove()).thenReturn(qOrAbove)
        `when`(permissionService.requestPermission(activityPluginBinding.activity, permissions, REQUEST_CODE_PERMISSION)).then {
            locationService.onRequestPermissionsResult(resultRequestCode, permissions, requestResults)
        }

        var callbackCalled = false
        var requestResult: Boolean? = null
        locationService.requestPermission {
            callbackCalled = true
            requestResult = it
        }

        assertThat(callbackCalled, `is`(true))
        assertThat(this.requestResult, `is`(requestResult))
    }
}

class LocationServiceTest {
    private val buildVersionProvider = mock(BuildVersionProvider::class.java)
    private val permissionService = mock(PermissionService::class.java)
    private val locationEnabledService = mock(LocationEnabledService::class.java)

    private val locationService = LocationService(buildVersionProvider, permissionService, locationEnabledService)

    @Test
    fun shouldBindServiceToActivity() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)

        locationService.bind(activityPluginBinding)

        verify(activityPluginBinding).addRequestPermissionsResultListener(locationService)
    }

    @Test
    fun shouldUnbindServiceFromActivity() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)
        locationService.bind(activityPluginBinding)

        locationService.unbind()

        verify(activityPluginBinding).removeRequestPermissionsResultListener(locationService)
    }

    @Test
    fun shouldOpenSettings() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)
        val activity = mock(Activity::class.java)
        `when`(activityPluginBinding.activity).thenReturn(activity)
        locationService.bind(activityPluginBinding)

        locationService.openSettings()

        verify(activity).startActivity(any())
    }
}

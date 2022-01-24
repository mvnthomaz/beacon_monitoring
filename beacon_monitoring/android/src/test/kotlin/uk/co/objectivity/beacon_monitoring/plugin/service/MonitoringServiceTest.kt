// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import org.hamcrest.CoreMatchers.`is`
import org.junit.Assert.assertThat
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.mockito.Mockito.*
import uk.co.objectivity.beacon_monitoring.plugin.model.LocationPermission
import uk.co.objectivity.beacon_monitoring.plugin.model.LocationPermission.*

class MonitoringServiceTest {
    private val localStorageService = mock(LocalStorageService::class.java)
    private val beaconClient = mock(BeaconClient::class.java)
    private val bluetoothService = mock(BluetoothService::class.java)
    private val locationService = mock(LocationService::class.java)

    private val monitoringService = MonitoringService(localStorageService, beaconClient, bluetoothService, locationService)

    @Test
    fun shouldEnableBackgroundMonitoring() {
        // given
        val backgroundCallbackId = 10L
        val monitoringCallbackId = 100L

        `when`(bluetoothService.isEnabled()).thenReturn(true)
        `when`(locationService.isEnabled()).thenReturn(true)
        `when`(locationService.checkPermission()).thenReturn(ALWAYS)

        // when
        monitoringService.startBackgroundMonitoring(backgroundCallbackId, monitoringCallbackId)

        // then
        verify(beaconClient).enableBackgroundMonitoring()
    }

    @Test
    fun shouldDisableBackgroundMonitoring() {
        // when
        monitoringService.stopBackgroundMonitoring()

        // then
        verify(beaconClient).disableBackgroundMonitoring()
    }
}

@RunWith(Parameterized::class)
class AllRequirementsMetTest(private val bluetoothEnabled: Boolean,
                             private val locationEnabled: Boolean,
                             private val locationPermission: LocationPermission,
                             private val result: Boolean) {

    private val localStorageService = mock(LocalStorageService::class.java)
    private val beaconClient = mock(BeaconClient::class.java)
    private val bluetoothService = mock(BluetoothService::class.java)
    private val locationService = mock(LocationService::class.java)

    private val monitoringService = MonitoringService(localStorageService, beaconClient, bluetoothService, locationService)

    companion object {
        @JvmStatic
        @Parameterized.Parameters
        fun data(): Collection<Array<Any>> {
            return listOf(
                    arrayOf(true, true, ALWAYS, true),
                    arrayOf(false, true, ALWAYS, false),
                    arrayOf(true, false, ALWAYS, false),
                    arrayOf(false, false, ALWAYS, false),
                    arrayOf(true, true, WHILE_IN_USE, false),
                    arrayOf(true, true, DENIED, false)
            )
        }
    }

    @Test
    fun shouldCheckAllRequirements() {
        // given
        `when`(bluetoothService.isEnabled()).thenReturn(bluetoothEnabled)
        `when`(locationService.isEnabled()).thenReturn(locationEnabled)
        `when`(locationService.checkPermission()).thenReturn(locationPermission)

        // when
        val allRequirementsMet = monitoringService.allRequirementsMet(ALWAYS)

        // then
        assertThat(allRequirementsMet, `is`(result))
    }
}

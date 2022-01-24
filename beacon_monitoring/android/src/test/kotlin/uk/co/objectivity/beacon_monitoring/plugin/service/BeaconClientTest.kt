// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.MonitorNotifier.INSIDE
import org.altbeacon.beacon.Region
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*

class BeaconClientTest {
    private val bluetoothAddress = "1A:1A:1A:1A:1A:1A"

    private val context = mock(Context::class.java)
    private val beaconManager = mock(BeaconManager::class.java)
    private val localStorageService = mock(LocalStorageService::class.java)
    private val notificationService = mock(NotificationService::class.java)
    private val testClass = mock(TestClass::class.java)

    private val beaconClient = BeaconClient(context, beaconManager, localStorageService, notificationService)

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun shouldStopRangingAndInvokeMonitoringNotifier() {
        // given
        val region = createRegion();

        init(region)

        // when
        beaconClient.didExitRegion(region)

        // then
        verify(beaconManager).stopRangingBeaconsInRegion(region)
        verify(testClass).testMethod()
    }

    @Test
    fun shouldStartRangingAndInvokeMonitoringNotifier() {
        // given
        val region = createRegion();

        init(region)

        // when
        beaconClient.didEnterRegion(region)

        // then
        verify(beaconManager).startRangingBeaconsInRegion(region)
        verify(testClass).testMethod()
    }

    @Test
    fun shouldInvokeMonitoringNotifier() {
        // given
        val region = createRegion();

        init(region)

        // when
        beaconClient.didDetermineStateForRegion(INSIDE, region);

        // then
        verify(testClass).testMethod()
    }

    @Test
    fun shouldInvokeRangingNotifier() {
        // given
        val region = createRegion();
        val beacon = mock(Beacon::class.java)

        init(region)

        `when`(beacon.bluetoothAddress).thenReturn(bluetoothAddress)

        // when
        beaconClient.didRangeBeaconsInRegion(mutableListOf(beacon), region);

        // then
        verify(testClass).testMethod()
    }

    private fun init(region: Region) {
        initContext()

        beaconClient.addRegion(region)
        beaconClient.monitoringNotifier = { testClass.testMethod() }
        beaconClient.rangingNotifier = { testClass.testMethod() }
    }

    private fun initContext() {
        val packageName = "packageName"
        val activityManager = mock(ActivityManager::class.java)
        val packageManager = mock(PackageManager::class.java)

        `when`(packageManager.queryIntentServices(any(Intent::class.java), anyInt())).thenReturn(mutableListOf(ResolveInfo()))
        `when`(context.applicationContext).thenReturn(context)
        `when`(context.getSystemService("activity")).thenReturn(activityManager)
        `when`(context.packageName).thenReturn(packageName)
        `when`(context.packageManager).thenReturn(packageManager)
    }

    private fun createRegion(): Region {
        val uniqueId = "asd123";
        return Region(uniqueId, bluetoothAddress)
    }

    class TestClass {
        fun testMethod(): String {
            return "test"
        }
    }
}
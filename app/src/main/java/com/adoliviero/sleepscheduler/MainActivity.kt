package com.adoliviero.sleepscheduler

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.adoliviero.sleepscheduler.ui.theme.SleepSchedulerTheme
import java.time.Duration
import java.time.LocalTime
import java.time.format.DateTimeFormatter

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            SleepSchedulerTheme {
                SleepSchedulerApp()
            }
        }
    }
}

@Composable
fun SleepSchedulerApp() {
    val navController = rememberNavController()
    var selectedSleepTime by remember { mutableStateOf(LocalTime.now()) }
    var selectedWakeUpTime by remember { mutableStateOf(LocalTime.now().plusMinutes((7*60) + 30)) } // Default to current time + 7h30m

    NavHost(navController = navController, startDestination = "main") {
        composable("main") {
            MainScreen(
                navController = navController,
                selectedSleepTime = selectedSleepTime,
                selectedWakeUpTime = selectedWakeUpTime,
                onSleepTimeSelected = { time -> selectedSleepTime = time },
                onWakeUpTimeSelected = { time -> selectedWakeUpTime = time }
            )
        }
        composable("sleepTimeList") {
            SleepTimeListScreen(selectedSleepTime)
        }
        composable("wakeUpTimeList") {
            WakeUpTimeListScreen(selectedWakeUpTime)
        }
    }
}

@Composable
fun MainScreen(
    navController: androidx.navigation.NavController,
    selectedSleepTime: LocalTime,
    selectedWakeUpTime: LocalTime,
    onSleepTimeSelected: (LocalTime) -> Unit,
    onWakeUpTimeSelected: (LocalTime) -> Unit
) {
    val timeFormatter = DateTimeFormatter.ofPattern("HH:mm")
    var showSleepTimePicker by remember { mutableStateOf(false) }
    var showWakeUpTimePicker by remember { mutableStateOf(false) }

    Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Button(
                onClick = { showSleepTimePicker = true },
                modifier = Modifier.padding(16.dp)
            ) {
                Text(text = "Start sleeping at ${selectedSleepTime.format(timeFormatter)}")
            }
            Button(
                onClick = { showWakeUpTimePicker = true },
                modifier = Modifier.padding(16.dp)
            ) {
                Text(text = "Wake up at ${selectedWakeUpTime.format(timeFormatter)}")
            }
        }
    }

    if (showSleepTimePicker) {
        TimePickerDialog(
            initialTime = selectedSleepTime,
            onTimeSelected = { time ->
                onSleepTimeSelected(time)
                showSleepTimePicker = false
                navController.navigate("sleepTimeList")
            },
            onDismiss = { showSleepTimePicker = false }
        )
    }

    if (showWakeUpTimePicker) {
        TimePickerDialog(
            initialTime = selectedWakeUpTime,
            onTimeSelected = { time ->
                onWakeUpTimeSelected(time)
                showWakeUpTimePicker = false
                navController.navigate("wakeUpTimeList")
            },
            onDismiss = { showWakeUpTimePicker = false }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TimePickerDialog(
    initialTime: LocalTime,
    onTimeSelected: (LocalTime) -> Unit,
    onDismiss: () -> Unit
) {
    val timePickerState = rememberTimePickerState(
        initialHour = initialTime.hour,
        initialMinute = initialTime.minute
    )

    Dialog(onDismissRequest = onDismiss) {
        Surface(
            shape = MaterialTheme.shapes.medium,
            modifier = Modifier.wrapContentSize()
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(text = "Select Time", style = MaterialTheme.typography.titleMedium)
                Spacer(modifier = Modifier.height(16.dp))
                TimePicker(state = timePickerState)
                Spacer(modifier = Modifier.height(16.dp))
                Button(onClick = {
                    val pickedTime = LocalTime.of(timePickerState.hour, timePickerState.minute)
                    onTimeSelected(pickedTime)
                }) {
                    Text(text = "Select")
                }
            }
        }
    }
}

@Composable
fun SleepTimeListScreen(selectedSleepTime: LocalTime) {
    val timeFormatter = DateTimeFormatter.ofPattern("HH:mm")
    val intervalMinutes = 90 // 90 minutes interval
    val maxSleepDurationMinutes = 9 * 60 // 9 hours
    val times = generateTimesFromSleep(selectedSleepTime, intervalMinutes, maxSleepDurationMinutes)

    Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            // Top labels
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(text = "Wake up at", style = MaterialTheme.typography.titleMedium)
                Text(text = "Sleep amount", style = MaterialTheme.typography.titleMedium)
            }
            // List of cards
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                items(times) { (wakeUpTime, sleepDuration) ->
                    TimeCard(
                        targetTime = wakeUpTime,
                        timeFormatter = timeFormatter,
                        sleepDuration = sleepDuration
                    )
                }
            }
        }
    }
}


@Composable
fun WakeUpTimeListScreen(selectedWakeUpTime: LocalTime) {
    val timeFormatter = DateTimeFormatter.ofPattern("HH:mm")
    val intervalMinutes = 90 // 90 minutes interval
    val maxSleepDurationMinutes = 9 * 60 // 9 hours
    val times = generateTimesFromWakeUp(selectedWakeUpTime, intervalMinutes, maxSleepDurationMinutes)

    Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            // Top labels
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(text = "Sleep at", style = MaterialTheme.typography.titleMedium)
                Text(text = "Sleep amount", style = MaterialTheme.typography.titleMedium)
            }
            // List of cards
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(times) { (sleepTime, sleepDuration) ->
                    TimeCard(
                        targetTime = sleepTime,
                        timeFormatter = timeFormatter,
                        sleepDuration = sleepDuration
                    )
                }
            }
        }
    }
}

@Composable
fun TimeCard(targetTime: LocalTime, timeFormatter: DateTimeFormatter, sleepDuration: Duration) {
    val hours = sleepDuration.toHours()
    val minutes = sleepDuration.toMinutes() % 60

    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = targetTime.format(timeFormatter),
                style = MaterialTheme.typography.titleMedium
            )
            Text(
                text = "${hours}h" + if (minutes > 0) " ${minutes}m" else "",
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}

fun generateTimesFromSleep(selectedSleepTime: LocalTime, intervalMinutes: Int, maxSleepDurationMinutes: Int): List<Pair<LocalTime, Duration>> {
    val times = mutableListOf<Pair<LocalTime, Duration>>()
    var currentTime = selectedSleepTime
    var currentSleepAmount = Duration.ZERO

    while (currentSleepAmount.toMinutes() <= maxSleepDurationMinutes) {
        times.add(currentTime to currentSleepAmount)
        currentTime = currentTime.plusMinutes(intervalMinutes.toLong())
        currentSleepAmount = currentSleepAmount.plusMinutes(intervalMinutes.toLong())
    }

    return times
}

fun generateTimesFromWakeUp(selectedWakeUpTime: LocalTime, intervalMinutes: Int, maxSleepDurationMinutes: Int): List<Pair<LocalTime, Duration>> {
    val times = mutableListOf<Pair<LocalTime, Duration>>()
    var currentTime = selectedWakeUpTime
    var currentSleepAmount = Duration.ZERO
    val currentTimeNow = LocalTime.now()

    // First, generate all wake-up times
    while (currentSleepAmount.toMinutes() <= maxSleepDurationMinutes) {
        times.add(currentTime to currentSleepAmount)
        currentTime = currentTime.minusMinutes(intervalMinutes.toLong())
        currentSleepAmount = currentSleepAmount.plusMinutes(intervalMinutes.toLong())
    }

    // Reverse the list to start from the earliest time
    val reversedTimes = times.reversed()

    // Find the closest wake-up time before the current time
    val closestTimeBeforeNow = reversedTimes.lastOrNull { it.first.isBefore(currentTimeNow) }

    // Filter the list to include only times after the current time, plus the closest time before now
    val filteredTimes = reversedTimes.filter { !it.first.isBefore(currentTimeNow) || it == closestTimeBeforeNow }

    return filteredTimes
}
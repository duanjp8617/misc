# The basic scheduler with only timer enabled.

## Initialization

1. The IO driver is just a ParkThread, which stops the execution of the thread and makes the thread sleep.

2. The timer driver **contains the IO driver**, and has a timer wheel implementation.

3. The basic scheduler actually wraps around the timer driver. As the comment says: " And now put a single-threaded scheduler on top of the timer. When
there are no futures ready to do something, it'll let the timer or
the reactor to generate some new stimuli for the futures to continue
in their life."

## BasicScheduler enter

1. A very tricky question of tokio is that all futures and tasks run within some kind of context, from which you can access timers and IO resources. 

2. To guarantee that this context is always available when running futures and tasks, tokio designs a special enter mechanism. The enter generally consists of the following steps:
    * A hiden thread-local variable is maintained by the tokio library, which is used to store the context that this thread should visit when running futures and tasks.
    * A tokio program must start by calling blocking_on on the scheduler, and passing in an initial future task that generate all following works of this tokio program.
    * Within blocking_on, the BasicScheduler will switch all the available resources (tiemrs, IO resources) into the thread-local variable, and then proceed to run the init future task.
    * To ensure that the available resources are properly switched out even when the init future panics, tokio uses a guard struct to handle the switch-out of the resources from the thread-local variable.

## Basic Scheduler Inner Lock

1. Basic Scheduler has an locked Inner, which handles all the work behind the scene. Theoretically this lock should be able to protect different threads from concurrently accessing the Inner. However, I have really been able to replicate it.

2. Before doing the actual work, the lock will be held and the Inner will be taken out of the BasicScheduler. But the inner will be placed back into the BasicScheduler using the same mechanism disccused above.

## Inner Context Enter

1. There is a second enter in tokio's Basic Scheduler.

2. For the Inner that was taken out in the previous step, tokio will perform a another enter which takes the task queue out from the Inner and store it inside a scoped thread local variable. 

3. Finally, the execution of the init future is done inside a closure, with the Inner and a reference to the Context as the input variable.

4. Tokio uses similar mechanism as discussed above to ensure that, if the init future panics, the task queue contained inside the scoped thread local variable will be switched out and placed back into the Inner.

## 

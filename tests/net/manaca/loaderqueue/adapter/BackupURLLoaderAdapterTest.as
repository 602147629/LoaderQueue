package net.manaca.loaderqueue.adapter
{
import flash.net.URLRequest;

import flexunit.framework.Assert;

import net.manaca.loaderqueue.ILoaderAdapter;
import net.manaca.loaderqueue.LoaderAdapterState;
import net.manaca.loaderqueue.LoaderQueue;
import net.manaca.loaderqueue.LoaderQueueEvent;
import net.manaca.loaderqueue.TestURL;

import org.flexunit.async.Async;

public class BackupURLLoaderAdapterTest
{		
    private var loaderQueue:LoaderQueue;
    private var loaderAdapter1:ILoaderAdapter;
    
    [Before]
    public function setUp():void
    {
        loaderQueue = new LoaderQueue();
    }
    
    [After]
    public function tearDown():void
    {
        loaderQueue.dispose();
        loaderQueue = null;
    }
    
    [Test(async)]
    public function testStart():void
    {
        loaderAdapter1 = new BackupURLLoaderAdapter(1,
            new URLRequest(TestURL.PIC1), new URLRequest(TestURL.PIC3));
        
        Async.handleEvent(this, loaderAdapter1, LoaderQueueEvent.TASK_COMPLETED, 
            verifyComplete, TestURL.WAIT_TIME, {});
        
        loaderQueue.addItem(loaderAdapter1);
    }
    
    private function verifyComplete(...arg):void
    {
        Assert.assertEquals(loaderAdapter1.state, LoaderAdapterState.COMPLETED);
        Assert.assertEquals(loaderAdapter1.isCompleted, true);
        Assert.assertTrue(BackupURLLoaderAdapter(loaderAdapter1).data != null);
    }
    
    [Test(async)]
    public function testBackStart():void
    {
        loaderAdapter1 = new BackupURLLoaderAdapter(1,
            new URLRequest(TestURL.ERROR), new URLRequest(TestURL.PIC3));
        
        Async.handleEvent(this, loaderAdapter1, LoaderQueueEvent.TASK_COMPLETED, 
            verifyBackComplete, TestURL.WAIT_TIME, {});
        
        loaderQueue.addItem(loaderAdapter1);
    }
    
    private function verifyBackComplete(...arg):void
    {
        Assert.assertEquals(loaderAdapter1.state, LoaderAdapterState.COMPLETED);
        Assert.assertEquals(loaderAdapter1.isCompleted, true);
        Assert.assertTrue(BackupURLLoaderAdapter(loaderAdapter1).data != null);
    }
}
}
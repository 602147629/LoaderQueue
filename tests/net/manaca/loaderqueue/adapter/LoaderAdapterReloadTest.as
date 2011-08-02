package net.manaca.loaderqueue.adapter
{
import flash.net.URLRequest;

import flexunit.framework.Assert;

import net.manaca.loaderqueue.LoaderQueue;
import net.manaca.loaderqueue.LoaderQueueEvent;
import net.manaca.loaderqueue.TestURL;

import org.flexunit.async.Async;

public class LoaderAdapterReloadTest
{		
    private var loaderQueue:LoaderQueue;
    private var loaderAdapter1:LoaderAdapter;
    
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
    public function testNormalLoad():void
    {
        loaderAdapter1 = new LoaderAdapter(1, new URLRequest(TestURL.PIC1));
        Async.handleEvent(this, loaderAdapter1, LoaderQueueEvent.TASK_COMPLETED, 
            verifyCompleteNumTries, TestURL.WAIT_TIME, {});
        
        loaderQueue.addItem(loaderAdapter1);
    }
    
    private function verifyCompleteNumTries(...arg):void
    {
        Assert.assertEquals(loaderAdapter1.numTries, 0);
    }
    
    [Test(async)]
    public function testErrorLoad():void
    {
        loaderAdapter1 = new LoaderAdapter(1, new URLRequest(TestURL.ERROR));
        loaderAdapter1.maxTries = 4;
        Async.handleEvent(this, loaderAdapter1, LoaderQueueEvent.TASK_ERROR, 
            verifyErrorNumTries, TestURL.WAIT_TIME, {});
        
        loaderQueue.addItem(loaderAdapter1);
    }
    
    private function verifyErrorNumTries(...arg):void
    {
        Assert.assertEquals(loaderAdapter1.numTries, loaderAdapter1.maxTries);
    }
}
}
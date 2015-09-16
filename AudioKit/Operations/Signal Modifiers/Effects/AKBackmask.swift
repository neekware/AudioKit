//
//  AKBackmask.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Store a signal inside a buffer and play it back reversed.

Backmasking is a recording technique in which a sound or message is recorded backward onto a track that is meant to be played forward. Backmasking is a deliberate process, whereas a message found through phonetic reversal may be unintentional.
*/
@objc class AKBackmask : AKParameter {

    // MARK: - Properties

    private var reverse = UnsafeMutablePointer<sp_reverse>.alloc(1)

    private var input = AKParameter()

    /** Delay time in seconds. [Default Value: 1.0] */
    private var delay: Float = 0



    // MARK: - Initializers

    /** Instantiates the backmask with default values

    - parameter input: Input audio signal. 
    */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates backmask with constants

    - parameter input: Input audio signal. 
    - parameter delay: Delay time in seconds. [Default Value: 1.0]
    */
    init (input sourceInput: AKParameter, delay delayInput: Float) {
        super.init()
        input = sourceInput
        setup(delayInput)
        dependencies = [input]
        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal backmask */
    internal func bindAll() {
    }

    /** Internal set up function */
    internal func setup(delay: Float = 1.0) {
        sp_reverse_create(&reverse)
        sp_reverse_init(AKManager.sharedManager.data, reverse, delay)
    }

    /** Computation of the next value */
    override func compute() {
        sp_reverse_compute(AKManager.sharedManager.data, reverse, &(input.leftOutput), &leftOutput);
        sp_reverse_compute(AKManager.sharedManager.data, reverse, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_reverse_destroy(&reverse)
    }
}

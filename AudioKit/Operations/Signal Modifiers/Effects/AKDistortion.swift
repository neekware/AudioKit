//
//  AKDistortion.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Distortion using a modified hyperbolic tangent function.


*/
@objc class AKDistortion : AKParameter {

    // MARK: - Properties

    private var dist = UnsafeMutablePointer<sp_dist>.alloc(1)

    private var input = AKParameter()


    /** Determines the amount of gain applied to the signal before waveshaping. A value of 1 gives slight distortion. [Default Value: 2.0] */
    var pregain: AKParameter = akp(2.0) {
        didSet {
            pregain.bind(&dist.memory.pregain)
            dependencies.append(pregain)
        }
    }

    /** Shape of the positive part of the signal. A value of 0 gets a flat clip. [Default Value: 0] */
    var postiveShapeParameter: AKParameter = akp(0) {
        didSet {
            postiveShapeParameter.bind(&dist.memory.shape1)
            dependencies.append(postiveShapeParameter)
        }
    }

    /** Like shape1, only for the negative part. [Default Value: 0] */
    var negativeShapeParameter: AKParameter = akp(0) {
        didSet {
            negativeShapeParameter.bind(&dist.memory.shape2)
            dependencies.append(negativeShapeParameter)
        }
    }

    /** Gain applied after waveshaping [Default Value: 0.5] */
    var postgain: AKParameter = akp(0.5) {
        didSet {
            postgain.bind(&dist.memory.postgain)
            dependencies.append(postgain)
        }
    }


    // MARK: - Initializers

    /** Instantiates the distortion with default values

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

    /** Instantiates the distortion with all values

    - parameter input: Input audio signal. 
    - parameter pregain: Determines the amount of gain applied to the signal before waveshaping. A value of 1 gives slight distortion. [Default Value: 2.0]
    - parameter postiveShapeParameter: Shape of the positive part of the signal. A value of 0 gets a flat clip. [Default Value: 0]
    - parameter negativeShapeParameter: Like shape1, only for the negative part. [Default Value: 0]
    - parameter postgain: Gain applied after waveshaping [Default Value: 0.5]
    */
    convenience init(
        input                  sourceInput:   AKParameter,
        pregain                pregainInput:  AKParameter,
        postiveShapeParameter  shape1Input:   AKParameter,
        negativeShapeParameter shape2Input:   AKParameter,
        postgain               postgainInput: AKParameter)
    {
        self.init(input: sourceInput)
        pregain                = pregainInput
        postiveShapeParameter  = shape1Input
        negativeShapeParameter = shape2Input
        postgain               = postgainInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal distortion */
    internal func bindAll() {
        pregain               .bind(&dist.memory.pregain)
        postiveShapeParameter .bind(&dist.memory.shape1)
        negativeShapeParameter.bind(&dist.memory.shape2)
        postgain              .bind(&dist.memory.postgain)
        dependencies.append(pregain)
        dependencies.append(postiveShapeParameter)
        dependencies.append(negativeShapeParameter)
        dependencies.append(postgain)
    }

    /** Internal set up function */
    internal func setup() {
        sp_dist_create(&dist)
        sp_dist_init(AKManager.sharedManager.data, dist)
    }

    /** Computation of the next value */
    override func compute() {
        sp_dist_compute(AKManager.sharedManager.data, dist, &(input.leftOutput), &leftOutput);
        sp_dist_compute(AKManager.sharedManager.data, dist, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_dist_destroy(&dist)
    }
}

/*
 * Copyright (C) 2018-2023 Toshiaki Maki <makingx@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package am.ik.yavi.arguments;

import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.function.Supplier;

import am.ik.yavi.core.ConstraintContext;
import am.ik.yavi.core.ConstraintGroup;
import am.ik.yavi.core.ConstraintViolationsException;
import am.ik.yavi.core.Validatable;
import am.ik.yavi.core.Validated;
import am.ik.yavi.core.ValueValidator;
import am.ik.yavi.jsr305.Nullable;

/**
 * Generated by https://github.com/making/yavi/blob/develop/scripts/generate-args.sh
 *
 * @since 0.3.0
 */
@FunctionalInterface
public interface Arguments1Validator<A1, X> extends ValueValidator<A1, X> {

	/**
	 * Convert {@link Validatable} instance into {@link Arguments1Validator}
	 *
	 * @param validator core validator
	 * @param <X> target class
	 * @return arguments1 validator
	 * @since 0.8.0
	 */
	static <X> Arguments1Validator<X, X> from(Validatable<X> validator) {
		return Arguments1Validator.from(validator.applicative());
	}

	/**
	 * Convert {@link ValueValidator} instance into {@link Arguments1Validator}
	 *
	 * @param valueValidator value validator
	 * @param <A1> class of argument1
	 * @param <X> target class
	 * @return arguments1 validator
	 * @since 0.8.0
	 */
	static <A1, X> Arguments1Validator<A1, X> from(ValueValidator<A1, X> valueValidator) {
		return valueValidator::validate;
	}

	@Override
	Validated<X> validate(@Nullable A1 a1, Locale locale,
			ConstraintContext constraintContext);

	/**
	 * @since 0.7.0
	 */
	@Override
	default <X2> Arguments1Validator<A1, X2> andThen(
			Function<? super X, ? extends X2> mapper) {
		return (a1, locale, constraintContext) -> Arguments1Validator.this
				.validate(a1, locale, constraintContext).map(mapper);
	}

	/**
	 * @since 0.11.0
	 */
	@Override
	default <X2> Arguments1Validator<A1, X2> andThen(
			ValueValidator<? super X, X2> validator) {
		return (a1, locale, constraintContext) -> Arguments1Validator.this
				.validate(a1, locale, constraintContext)
				.flatMap(v -> validator.validate(v, locale, constraintContext));
	}

	/**
	 * @since 0.7.0
	 */
	@Override
	default <A> Arguments1Validator<A, X> compose(
			Function<? super A, ? extends A1> mapper) {
		return (a, locale, constraintContext) -> Arguments1Validator.this
				.validate(mapper.apply(a), locale, constraintContext);
	}

	/**
	 * @since 0.10.0
	 */
	default Arguments1Validator<A1, Supplier<X>> lazy() {
		// WARNING:: The default implementation is not really lazy!
		java.util.logging.Logger.getLogger(Arguments1Validator.class.getName()).warning(
				"the default implementation of lazy() is called which is not really lazy!");
		return this.andThen(x -> () -> x);
	}

	default Validated<X> validate(@Nullable A1 a1) {
		return this.validate(a1, Locale.getDefault(), ConstraintGroup.DEFAULT);
	}

	default Validated<X> validate(@Nullable A1 a1, ConstraintContext constraintContext) {
		return this.validate(a1, Locale.getDefault(), constraintContext);
	}

	default Validated<X> validate(@Nullable A1 a1, Locale locale) {
		return this.validate(a1, locale, ConstraintGroup.DEFAULT);
	}

	default X validated(@Nullable A1 a1) throws ConstraintViolationsException {
		return this.validate(a1).orElseThrow(ConstraintViolationsException::new);
	}

	default X validated(@Nullable A1 a1, ConstraintContext constraintContext)
			throws ConstraintViolationsException {
		return this.validate(a1, constraintContext)
				.orElseThrow(ConstraintViolationsException::new);
	}

	default X validated(@Nullable A1 a1, Locale locale)
			throws ConstraintViolationsException {
		return this.validate(a1, locale).orElseThrow(ConstraintViolationsException::new);
	}

	default X validated(@Nullable A1 a1, Locale locale,
			ConstraintContext constraintContext) throws ConstraintViolationsException {
		return this.validate(a1, locale, constraintContext)
				.orElseThrow(ConstraintViolationsException::new);
	}

	/**
	 * @since 0.7.0
	 */
	default <A2, Y> Arguments2Splitting<A1, A2, X, Y> split(
			ValueValidator<A2, Y> validator) {
		return new Arguments2Splitting<>(this, validator);
	}

	/**
	 * @since 0.7.0
	 */
	default <Y> Arguments2Combining<A1, X, Y> combine(ValueValidator<A1, Y> validator) {
		return new Arguments2Combining<>(this, validator);
	}

	/**
	 * @since 0.7.0
	 */
	@Override
	default Arguments1Validator<A1, X> indexed(int index) {
		return (a1, locale, constraintContext) -> Arguments1Validator.this
				.validate(a1, locale, constraintContext).indexed(index);
	}

	/**
	 * @since 0.8.0
	 */
	default <C extends Collection<X>> Arguments1Validator<Iterable<A1>, C> liftCollection(
			Supplier<C> factory) {
		return Arguments1Validator.from(ValueValidator.super.liftCollection(factory));
	}

	/**
	 * @since 0.8.0
	 */
	default Arguments1Validator<Iterable<A1>, List<X>> liftList() {
		return Arguments1Validator.from(ValueValidator.super.liftList());
	}

	/**
	 * @since 0.8.0
	 */
	default Arguments1Validator<Iterable<A1>, Set<X>> liftSet() {
		return Arguments1Validator.from(ValueValidator.super.liftSet());
	}

	/**
	 * @since 0.8.0
	 */
	default Arguments1Validator<Optional<A1>, Optional<X>> liftOptional() {
		return Arguments1Validator.from(ValueValidator.super.liftOptional());
	}
}
